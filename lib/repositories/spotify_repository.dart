import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';
import 'package:musicmate/models/spotify/recommended_songs.dart';

abstract class SpotifyRepository {

  Future<void> generateAccessToken();
  Future<String?> getAccessToken();
  Future<Categories?>? getBrowseCategories();
  Future<Albums?>? getLatestReleases();
  Future<Albums?>? getMoreRelease(String nextUrl);
  Future<String?> getVideoId(String songName, List<String> artistName);
  Future<List<Track>?>? getRecommendedSongs(List<String> artistsId);
}