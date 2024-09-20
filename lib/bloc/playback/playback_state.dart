part of 'playback_bloc.dart';

@immutable
abstract class SongsPlaybackState {}

class PlaybackInitial extends SongsPlaybackState {
  final String? videoId;
  final String? spotifyId;
  final UserModel? currentUser;

  PlaybackInitial({this.videoId, this.spotifyId, this.currentUser});

  List<Object?> get props => [videoId, spotifyId, currentUser];
}

class PlaybackLoading extends PlaybackInitial {
  final bool isLoading;
  PlaybackLoading(
      {super.videoId,
      super.spotifyId,
      super.currentUser,
      required this.isLoading});

  @override
  List<Object?> get props => [videoId, spotifyId, currentUser, isLoading];
}

class PlaybackSuccess extends PlaybackInitial {
  final List<Track?>? recommendedSongs;
  final List<String>? nextTrackIds;
  PlaybackSuccess(
      {super.videoId,
      super.spotifyId,
      super.currentUser,
      this.recommendedSongs,
      this.nextTrackIds});

  @override
  List<Object?> get props =>
      [videoId, spotifyId, currentUser, recommendedSongs];
}

class PlaybackError extends PlaybackInitial {
  final String errorMessage;

  PlaybackError(
      {super.videoId,
      super.spotifyId,
      super.currentUser,
      required this.errorMessage});

  @override
  List<Object?> get props => [videoId, spotifyId, currentUser, errorMessage];
}
