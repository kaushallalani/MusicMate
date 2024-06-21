part of 'playback_bloc.dart';

@immutable
abstract class PlaybackEvent {}

class OnPlaySong extends PlaybackEvent {
  final String songName;
  final List<String> artistName;

  OnPlaySong({required this.songName, required this.artistName});
}

class OnGetRecommendedSongs extends PlaybackEvent {
  final List<String> artistId;

  OnGetRecommendedSongs({required this.artistId});
}
