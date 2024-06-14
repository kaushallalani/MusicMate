import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/auth_repository.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';

import '../../repositories/user_repository.dart';

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
        if (userData != null) {
          userRepository.saveUserData(userData);
          emit(
              DashboardSuccessState(currentUser: userRepository.userDataModel));
        } else {
          emit(DashboardFailureState(
              errorMessage: 'Error fetching userdetails'));
        }
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
        if (sessionId != null) {
          final sessionData =
              await dashboardRepository.fetchCurrentSessionDetails(sessionId);
          Logger().d(sessionData!.allUsers);
          userRepository.saveSessionData(sessionData!);
          emit(SessionSuccessState(
              sessionId: sessionId,
              sessionData: userRepository.sessionDataModel,
              userSessions: []));
        } else {
          emit(SessionErrorState(
              errorMessage: 'Error adding session to database'));
        }

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
        if (userSessions != null) {
          emit(SessionSuccessState(
              sessionId: null, sessionData: null, userSessions: userSessions));
        } else {
          emit(SessionErrorState(
              errorMessage: 'Error fetching all user sessions'));
        }
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
          emit(SessionSuccessState(
              sessionId: null, sessionData: sessionData, userSessions: []));
        } else {
          emit(SessionErrorState(errorMessage: 'Error fetching userdetails'));
        }

        emit(DashboardLoadingState(isLoading: false));
      } on Exception catch (e) {
        print('get  sessiobn error');
        print(e.toString());
      }
    });

    on<SetCurrentSession>((event, emit) async {
      try {
        userRepository.saveSessionData(event.sessionModel);
      } on Exception catch (e) {
        print('set error');
        print(e.toString());
      }
    });
  }
}
