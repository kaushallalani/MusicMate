import 'package:musicmate/models/spotify/albumsData.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';

abstract class SpotifyRepository {

  Future<void> generateAccessToken();
  Future<String?> getAccessToken();
  Future<Categories?>? getBrowseCategories();
  Future<Albums?>? getLatestReleases();
}