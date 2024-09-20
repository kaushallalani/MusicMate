part of 'playback_bloc.dart';

@immutable
abstract class SongsPlaybackEvent {}

class OnPlaySong extends SongsPlaybackEvent {
  final String songName;
  final List<String> artistName;

  OnPlaySong({required this.songName, required this.artistName});
}

class OnGetRecommendedSongs extends SongsPlaybackEvent {
  final List<String> artistId;

  OnGetRecommendedSongs({required this.artistId});
}

class onGetListOfVideoIds extends SongsPlaybackEvent {
  final List<String> songName;
  final List<List<String>> artistName;

  onGetListOfVideoIds({required this.songName, required this.artistName});
}

class OnDisplaySong extends SongsPlaybackEvent {
  final String songName;
  final List<String> artistName;

  OnDisplaySong({required this.songName, required this.artistName});
}

class onSaveCurrentAudioId extends SongsPlaybackEvent {
  final String videoId;

  onSaveCurrentAudioId({required this.videoId});
}
