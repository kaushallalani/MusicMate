import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/auth_repository.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';
import 'package:musicmate/repositories/spotify_repository.dart';
import 'package:musicmate/repositories/user_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final UserRepository userRepository;
  final DashboardRepository dashboardRepository;
  final FirebaseRepository firebaseRepository;
  final SpotifyRepository spotifyRepository;

  SessionBloc(this.userRepository, this.dashboardRepository,
      this.firebaseRepository, this.spotifyRepository)
      : super(SessionInitial()) {
    on<SessionEvent>((event, emit) {});

    on<FetchCurrentSession>((event, emit) {
      emit(SessionLoading(isLoading: true));
      try {
        final SessionModel? sessionData = userRepository.sessionDataModel;

        if (sessionData != null) {
          emit(SessionSuccessState(
              sessionData: sessionData, sessionUsers: const []));
        } else {
          emit(SessionErrorState(errorMessage: 'Error Loading session'));
        }
      } on FirebaseException catch (e) {
        print('get error in sesssion');
        print(e.toString());
      }
    });

    on<FetchSessionUserDetails>((event, emit) async {
      emit(SessionLoading(isLoading: true));

      try {
        final List<UserModel?> allUsers =
            await dashboardRepository.fetchSessionUsers(event.userIds);
        if (allUsers.isNotEmpty) {
          emit(SessionSuccessState(
              sessionData: userRepository.sessionDataModel,
              sessionUsers: allUsers));
        } else {
          emit(SessionErrorState(errorMessage: 'Error fecthing session users'));
        }
        emit(SessionLoading(isLoading: false));
      } catch (e) {
        print('fetch user session  error in sesssion');
        print(e.toString());
      }
    });

 
  }
}
