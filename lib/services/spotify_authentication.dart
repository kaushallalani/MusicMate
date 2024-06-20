import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/controllers/dio.dart';

class SpotifyAuthentication {
  final String ClientID = '3222f0dac2e24c908781642f43c8506d';
  final String ClientSecret = '31e95b4c7dd04ee0a7a285d23c4f36be';
  final DioController controller = DioController();
  final String ENDPOINT = 'https://api.spotify.com/v1';

  Future<String?> getAccessToken() async {
    print('acccc');
    const String authUrl = 'https://accounts.spotify.com/api/token';

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$ClientID:$ClientSecret'))}';

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
          Options(headers: {'authorization': 'Bearer $accessToken'}),
          'https://api.spotify.com/v1/browse/categories');

      if (dioResponse!.isNotEmpty) {
        return dioResponse;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchNewReleases(String accessToken, String url) async {
    if (accessToken.isNotEmpty) {     
      final dioResponse = await controller.getController(
          Options(headers: {'authorization': 'Bearer $accessToken'}),
          url);

      if (dioResponse!.isNotEmpty) {
        return dioResponse;
      }
    }
    return null;
  }
}
