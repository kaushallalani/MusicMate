import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/auth_repository.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';

import 'package:musicmate/repositories/user_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;
  final DashboardRepository dashboardRepository;

  DashboardBloc(
      this.userRepository, this.firebaseRepository, this.dashboardRepository)
      : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});

    on<FetchUserDataFromFirebase>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final UserModel? userData = await firebaseRepository.getCurrentUser();
        Logger().d(userData!.activeSessionId);
        userRepository.saveUserData(userData);
        emit(
            DashboardSuccessState(currentUser: userRepository.userDataModel));
              emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('fetch error');
        print(e.toString());
      }
    });

    on<GetUserDetails>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final userData = userRepository.userDataModel;
        Logger().d(userData);
        if (userData != null) {
          emit(DashboardSuccessState(currentUser: userData));
        } else {
          emit(DashboardFailureState(
              errorMessage: 'Error fetching userdetails'));
        }

        emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('get error');
        print(e.toString());
      }
    });

    on<CreateSession>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final sessionId =
            await dashboardRepository.createSession(event.sessionModel);
        Logger().d('sessionId');
        Logger().d(sessionId);
        final sessionData =
            await dashboardRepository.fetchCurrentSessionDetails(sessionId);
        Logger().d(sessionData!.allUsers);
        userRepository.saveSessionData(sessionData);
        emit(SessionLoadingSuccessState(
            sessionId: sessionId,
            sessionData: userRepository.sessionDataModel,
            userSessions: const []));

        emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('create session error');
        print(e.toString());
      }
    });

    on<FetchUserSessions>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final userSessions =
            await dashboardRepository.fetchAllUserSessions(event.id);
        Logger().d('sessionData');
        Logger().d(userSessions);
        emit(SessionLoadingSuccessState(
            sessionId: null, sessionData: null, userSessions: userSessions));
        emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('create session error');
        print(e.toString());
      }
    });

    on<GetSessionDetails>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final sessionData = userRepository.sessionDataModel;
        // Logger().d(sessionData!.sessionName);
        if (sessionData != null) {
          emit(SessionLoadingSuccessState(
              sessionId: null, sessionData: sessionData, userSessions: const []));
        } else {
          emit(SessionLoadingErrorState(errorMessage: 'Error fetching userdetails'));
        }

        emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('get  sessiobn error');
        print(e.toString());
      }
    });

    on<SetCurrentSession>((event, emit) async {
      try {
        print('in set sessiinnn');
        userRepository.saveSessionData(event.sessionModel);
      } on Exception catch (e) {
        print('set error');
        print(e.toString());
      }
    });

    on<JoinSession>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));

      try {
        final dynamic sessionData =
            await dashboardRepository.joinSession(event.code, event.userId);
        Logger().d(sessionData);
        if (sessionData is String) {
          emit(SessionLoadingErrorState(errorMessage: sessionData));
        } else if (sessionData is SessionModel &&
            sessionData.ownerId != null) {
          print('in true');
          add(  SetCurrentSession(sessionModel: sessionData));
        
          emit(SessionLoadingSuccessState(
            sessionId: sessionData.id,
            sessionData: sessionData,
          ));
        } else {
          print('in error');
          emit(SessionLoadingErrorState(errorMessage: 'Invalid Session Code'));
        }

        emit(DashboardLoadingState(isLoading: false));
      } catch (e) {
        print('join user session error ');
        print(e.toString());
      }
    });
  }
}
