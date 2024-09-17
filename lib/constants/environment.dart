// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get ClientId => dotenv.env['CLIENT_ID']!;
  static String get ClientSecret => dotenv.env['CLIENT_SECRET']!;
  static String get BASEURL => dotenv.env['BASEURL']!;
  static String get YT_API_KEY => dotenv.env['API_KEY']!;
  static String get YT_BASEURL => dotenv.env['YT_BASEURL']!;
  static String get AUTH_TOKEN => "https://accounts.spotify.com/api/token";
  static String get BROWSE_CATEGORIES => "$BASEURL/v1/browse/categories";
  static String get RECOMMENDATIONS => "$BASEURL/v1/recommendations";
  static String get YOUTUBE_SEARCH => "$YT_BASEURL/v3/search";
  static String get NEW_RELEASE => '$BASEURL/v1/browse/new-releases';
}
