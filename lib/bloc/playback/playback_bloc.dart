import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:musicmate/models/spotify/recommended_songs.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/spotify_repository.dart';
import 'package:musicmate/repositories/user_repository.dart';

part 'playback_event.dart';
part 'playback_state.dart';

class PlaybackBloc extends Bloc<PlaybackEvent, PlaybackState> {
  final SpotifyRepository spotifyRepository;
  final UserRepository userRepository;
  PlaybackBloc(this.spotifyRepository, this.userRepository)
      : super(PlaybackInitial()) {
    on<PlaybackEvent>((event, emit) {});

    on<OnPlaySong>((event, emit) async {
      try {
        final videoId = await spotifyRepository.getVideoId(
            event.songName, event.artistName);

        if (videoId != null) {
          userRepository.saveCurrentSongId(videoId);
          Logger().d('playyy => $videoId');
          emit(PlaybackSuccess(
              currentUser: userRepository.userDataModel, videoId: videoId));
        } else {
          emit(PlaybackError(errorMessage: 'Error fetching videoID'));
        }
      } catch (e) {
        print('error fetching video id');
      }
    });

    on<OnGetRecommendedSongs>((event, emit) async {
      Logger().d('called rec');
      emit(PlaybackLoading(isLoading: true));
      try {
        final songs =
            await spotifyRepository.getRecommendedSongs(event.artistId);
        if (songs?.length != 0) {
          Logger().d(songs);
          emit(PlaybackSuccess(
              recommendedSongs: songs, videoId: userRepository.currentSongId));
        } else {
          PlaybackError(errorMessage: 'Error fetching recommended songs');
        }
        emit(PlaybackLoading(isLoading: false));
      } catch (e) {
        print('error fetching recomended songs');
      }
    });

    on<onGetListOfVideoIds>((event, emit) async {
      try {
        List<String>? songsIds = [];

        for (int i = 0; i < event.songName.length; i++) {
          final song = event.songName[i];
          final artists = event.artistName[i] ??
              []; // Handle the case where artistNames[i] might be null

          final songId = await spotifyRepository.getVideoId(song, artists);
          songsIds.add(songId!);
        }

        if (songsIds.isNotEmpty) {
          emit(PlaybackSuccess(nextTrackIds: songsIds));
        } else {
          emit(PlaybackError(errorMessage: 'error fetching ids'));
        }
      } catch (e) {
        print('error fetching list of songs ids');
      }
    });
  }
}
