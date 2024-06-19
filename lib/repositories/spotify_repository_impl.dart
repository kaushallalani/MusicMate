import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:musicmate/models/spotify/albumsData.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';
import 'package:musicmate/repositories/spotify_repository.dart';
import 'package:musicmate/repositories/user_repository.dart';
import 'package:musicmate/services/spotify_authentication.dart';

class SpotifyRepositoryImpl extends SpotifyRepository {
  final SpotifyAuthentication spotifyAuthentication;
  final UserRepository userRepository;

  SpotifyRepositoryImpl(
      {required this.spotifyAuthentication, required this.userRepository});
  @override
  Future<void> generateAccessToken() async {
    try {
      final token = await spotifyAuthentication.getAccessToken();
      final DateTime tokenExpirationTime =
          DateTime.now().add(const Duration(hours: 1));

      Logger().d('Token => $token');
      if (token != null) {
        userRepository.saveAccessToken(token, tokenExpirationTime);
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final token = userRepository.accessToken;

      if (token != null) {
        return token;
      } else {
        return 'Error getting token';
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<Categories?>? getBrowseCategories() async {
    try {
      print('in categorieresss');
      final categoryData = await spotifyAuthentication
          .fetchBrowseCategories(userRepository.accessToken!);

      if (categoryData!.isNotEmpty) {
        final jsonData = BrowseCategories.fromJson(categoryData);
        Logger().d('Categories => $jsonData');
        return jsonData.categories;
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
    return null;
  }

  @override
  Future<Albums?>? getLatestReleases() async {
    try {
      final albumData = await spotifyAuthentication
          .fetchNewReleases(userRepository.accessToken!);
      if (albumData!.isNotEmpty) {
        Logger().d('Albums => ${albumData}');
        final jsonData = AlbumsData.fromJson(albumData);
          Logger().d('Albums => ${jsonData}');
        return jsonData.albums;
      }
    } on Exception catch (e) {
      return Future.error(e);
    }

    return null;
  }
}
