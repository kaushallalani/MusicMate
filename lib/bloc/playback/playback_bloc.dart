import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
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
      try {
        final songs =
            await spotifyRepository.getRecommendedSongs(event.artistId);
      } catch (e) {
        print('error fetching recomended songs');
      }
    });
  }
}
