import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/constants/environment.dart';
import 'package:musicmate/controllers/dio.dart';

class SpotifyAuthentication {
  final DioController controller = DioController();

  Future<String?> getAccessToken() async {
    final String authUrl = Environment.AUTH_TOKEN;

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('${Environment.ClientId}:${Environment.ClientSecret}'))}';

    final dioResponse = await controller.postController(
        Options(
          headers: {
            'authorization': basicAuth,
            'content-type': 'application/x-www-form-urlencoded'
          },
        ),
        authUrl,
        {'grant_type': 'client_credentials'});

    return dioResponse['access_token'];
  }

  Future<Map<String, dynamic>?> fetchBrowseCategories(
      String accessToken) async {
    if (accessToken.isNotEmpty) {
      Logger().d(accessToken);
      final dioResponse = await controller.getController(
          url: Environment.BROWSE_CATEGORIES,
          options: Options(headers: {'authorization': 'Bearer $accessToken'}),
          queryParameters: null);

      if (dioResponse!.isNotEmpty) {
        return dioResponse;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchNewReleases(
      String accessToken, String url) async {
    log('${accessToken.isNotEmpty} ,ccccc');
    if (accessToken.isNotEmpty) {
      final dioResponse = await controller.getController(
          options: Options(headers: {'authorization': 'Bearer $accessToken'}),
          url: url,
          queryParameters: null);

      if (dioResponse!.isNotEmpty) {
        return dioResponse;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?>? fetchSearchSong(
      String songName, List<String> artistName) async {
    Logger().d('in search');
    final searchUrl = Environment.YOUTUBE_SEARCH;

    final Map<String, dynamic> queryParameters = {
      'part': 'snippet',
      'q': '$songName${artistName.join(' ')}',
      'key': Environment.YT_API_KEY,
      'type': 'video',
      'maxResults': '1'
    };

    if (songName != null) {
      final dioResponse = await controller.getController(
          options: null, url: searchUrl, queryParameters: queryParameters);
      if (dioResponse!.isNotEmpty) {
        return dioResponse;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?>? fetchRecommendedSongs(
      List<String> artistId, String accessToken) async {
    Logger().d('idsss => ${artistId.join(',')}');
    final Map<String, dynamic> queryParameters = {
      'seed_artists': artistId.join(','),
      'limit': 3
    };
    if (accessToken != null) {
      final dioResponse = await controller.getController(
          options: Options(headers: {'authorization': 'Bearer $accessToken'}),
          url: Environment.RECOMMENDATIONS,
          queryParameters: queryParameters);
      Logger().d('res $dioResponse');
      if (dioResponse!.isNotEmpty) {
        return dioResponse;
      }
    }

    return null;
  }
}
