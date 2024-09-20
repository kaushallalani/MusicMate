import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/constants/environment.dart';
import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';
import 'package:musicmate/models/spotify/recommended_songs.dart';
import 'package:musicmate/repositories/spotify_repository.dart';
import 'package:musicmate/repositories/user_repository.dart';
import 'package:musicmate/services/global_listeners.dart';
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
        GlobalListeners().setAuthToken(token);
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
      log(Environment.NEW_RELEASE);
      log('VALLLLL =>${userRepository.accessToken == null}');
      if (userRepository.accessToken != null) {
        log(userRepository.accessToken!);
      }
      final albumData = await spotifyAuthentication.fetchNewReleases(
          userRepository.accessToken!, Environment.NEW_RELEASE);
      log('ALBUMM DATA =>${albumData!.length}');

      if (albumData!.isNotEmpty) {
        final jsonData = AlbumData.fromJson(albumData);
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
        Logger().d('New Albums => ${jsonData.albums!.next}');
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
  Future<List<Track>?>? getRecommendedSongs(List<String> artistsId) async {
    print(artistsId);
    try {
      final songs = await spotifyAuthentication.fetchRecommendedSongs(
          artistsId, userRepository.accessToken!);

      log('RECOMMENNDEDDD =>${songs!.length}');
      if (songs!.isNotEmpty) {
        final jsonData = Tracks.fromJson(songs);
        Logger().d('recccccc1 => ${jsonData.tracks![1].name}');
        // jsonData.tracks!
        //     .forEach((data) => Logger().d('datata=> ${data.album!.albumType}'));
        final filteredData = jsonData.tracks!
            .where((data) => data.album!.albumType!.toLowerCase() == 'single')
            .toList();

        Logger().d('recccccc => ${filteredData}');
        return filteredData;
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
    return null;
  }
}
