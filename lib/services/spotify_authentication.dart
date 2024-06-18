import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class SpotifyAuthentication {
  final String ClientID = '3222f0dac2e24c908781642f43c8506d';
  final String ClientSecret = '31e95b4c7dd04ee0a7a285d23c4f36be';
  final dio = Dio();

  Future<String?> getAccessToken() async {
    print('acccc');
    const String authUrl = 'https://accounts.spotify.com/api/token';

    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$ClientID:$ClientSecret'))}';

    // dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     options.headers['Authorization'] = 'Bearer ${basicAuth}';
    //   },
    // ));
    // final response = await dio.post(authUrl);
    final response = await http.post(
      Uri.parse(authUrl),
      headers: {
        'Authorization': basicAuth,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      print('Failed to get token: ${response.statusCode}');
      print(response.body);
      return null;
    }
  }

  Future<void> fetchTracks() async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/browse/categories'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

Logger().d(response);
      if (response.statusCode == 200) {
        // Process the response
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("data");
        Logger().d(data); // Example: Print the data to the console
      } else {
        print('Failed to fetch tracks: ${response.statusCode}');
        print(response.body);
      }
    }
  }
}
