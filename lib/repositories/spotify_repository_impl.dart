import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';
import 'package:musicmate/models/spotify/recommended_songs.dart';
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
      final albumData = await spotifyAuthentication.fetchNewReleases(
          userRepository.accessToken!,
          'https://api.spotify.com/v1/browse/new-releases');
      if (albumData!.isNotEmpty) {
        Logger().d('Albums => ${albumData}');
        final jsonData = AlbumData.fromJson(albumData);
        Logger().d('Albums => ${jsonData.albums.items[0].albumType}');
        return jsonData.albums;
      }
    } on Exception catch (e) {
      return Future.error(e);
    }

    return null;
  }

  @override
  Future<Albums?>? getMoreRelease(String nextUrl) async {
    try {
      Logger().d('urlll => ${nextUrl}');
      final albumData = await spotifyAuthentication.fetchNewReleases(
          userRepository.accessToken!, nextUrl);
      if (albumData!.isNotEmpty) {
        Logger().d('Albums => ${albumData}');
        final jsonData = AlbumData.fromJson(albumData);
        Logger().d('New Albums => ${jsonData.albums.next}');
        return jsonData.albums;
      }
    } on Exception catch (e) {
      return Future.error(e);
    }

    return null;
  }

  @override
  Future<String?> getVideoId(String songName, List<String> artistName) async {
    try {
      final jsonResponse =
          await spotifyAuthentication.fetchSearchSong(songName, artistName);

      final videoId = jsonResponse!['items'][0]['id']['videoId'];
      Logger().d('videoId => ${jsonResponse['items'][0]['id']['videoId']}');
      if (videoId != null) {
        return videoId;
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
    return null;
  }

  @override
  Future<RecommendedSongs?>? getRecommendedSongs(List<String> artistsId) async {
    print(artistsId);
    try {
      final songs =
          await spotifyAuthentication.fetchRecommendedSongs(artistsId,userRepository.accessToken!);
      if (songs!.isNotEmpty) {
        final jsonData = RecommendedSongs.fromJson(songs);
        Logger().d('Rec => $jsonData');
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
  }
}
