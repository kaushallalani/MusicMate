import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';

abstract class SpotifyRepository {

  Future<void> generateAccessToken();
  Future<String?> getAccessToken();
  Future<Categories?>? getBrowseCategories();
  Future<Albums?>? getLatestReleases();
  Future<Albums?>? getMoreRelease(String nextUrl);
}