import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/constants/environment.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/spotify/albums_data.dart';
import 'package:musicmate/models/spotify/browseCategories.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/auth_repository.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';
import 'package:musicmate/repositories/spotify_repository.dart';

import 'package:musicmate/repositories/user_repository.dart';
import 'package:musicmate/services/global_listeners.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends HydratedBloc<DashboardEvent, DashboardState> {
  final UserRepository userRepository;
  final FirebaseRepository firebaseRepository;
  final DashboardRepository dashboardRepository;
  final SpotifyRepository spotifyRepository;

  DashboardBloc(this.userRepository, this.firebaseRepository,
      this.dashboardRepository, this.spotifyRepository)
      : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});

    on<FetchUserDataFromFirebase>((event, emit) async {
      // emit(DashboardLoadingState(isLoading: true));
      try {
        if (userRepository.userDataModel != null) {
          emit(
              DashboardSuccessState(currentUser: userRepository.userDataModel));
        } else {
          final UserModel? userData = await firebaseRepository.getCurrentUser();
          Logger().d(userData!.activeSessionId);
          userRepository.saveUserData(userData);
          emit(
              DashboardSuccessState(currentUser: userRepository.userDataModel));
        }
        // emit(DashboardLoadingState(isLoading: false));
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
        final currentUserData = await firebaseRepository.getCurrentUser();
        final sessionData =
            await dashboardRepository.fetchCurrentSessionDetails(sessionId);
        Logger().d(currentUserData!.activeSessionId);
        userRepository.saveSessionData(sessionData!);
        userRepository.saveUserData(currentUserData);
        emit(SessionLoadingSuccessState(
            currentUser: userRepository.userDataModel,
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
        if (sessionData != null) {
          emit(SessionLoadingSuccessState(
              sessionId: null,
              sessionData: sessionData,
              userSessions: const []));
        } else {
          emit(SessionLoadingErrorState(
              errorMessage: 'Error fetching userdetails'));
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
        final currentUserData = await firebaseRepository.getCurrentUser();
        Logger().d(currentUserData!.activeSessionId);
        userRepository.saveUserData(currentUserData);

        if (sessionData is String) {
          emit(SessionLoadingErrorState(errorMessage: sessionData));
        } else if (sessionData is SessionModel && sessionData.ownerId != null) {
          print('in true');
          add(SetCurrentSession(sessionModel: sessionData));

          emit(SessionLoadingSuccessState(
            currentUser: userRepository.userDataModel,
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

    on<GetToken>((event, emit) async {
      try {
        final token = await spotifyRepository.getAccessToken();
        if (token != null) {
          emit(DashboardSuccessState(
              currentUser: userRepository.userDataModel, accessToken: token));
        } else {
          emit(DashboardFailureState(
              errorMessage: 'Error fetching access token'));
        }
      } catch (e) {
        print(e.toString());
      }
    });
    on<GenerateAccessToken>((event, emit) async {
      try {
        if (userRepository.accessToken == null ||
            DateTime.now().isAfter(userRepository.tokenExpirationTime!)) {
          await spotifyRepository.generateAccessToken();
        }
        Logger().d('Saved Token => ${userRepository.accessToken}');
        GlobalListeners().setAuthToken(userRepository.accessToken!);
      } catch (e) {
        print('error generating token =>$e');
      }
    });

    on<GetBrowseCategories>((event, emit) async {
      // emit(DashboardLoadingState(isLoading: true));
      try {
        final categories = await spotifyRepository.getBrowseCategories();

        if (categories != null) {
          emit(DashboardSuccessState(categoriesData: categories));
        } else {
          emit(
              DashboardFailureState(errorMessage: 'Error Fetching Categories'));
        }

        emit(DashboardLoadingState(isLoading: false));
      } catch (e) {
        print('error fetching  categories');
      }
    });

    on<GetNewReleases>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        final albums = await spotifyRepository.getLatestReleases();
        print('inn albumsss => $albums');

        if (albums != null) {
          print('inn albumsss');

          userRepository.saveAlbumData(albums);
          userRepository.saveNewReleases(albums.items!);
          emit(DashboardSuccessState(albumsData: albums));
        } else {
          emit(DashboardFailureState(errorMessage: 'Error Fetching Releases'));
        }

        emit(DashboardLoadingState(isLoading: false));
      } catch (e) {
        print('error fetching latest release: s $e');
      }
    });

    on<FetchMoreReleases>((event, emit) async {
      try {
        final oldAlbumItemsData = userRepository.albumData;
        Logger().d(oldAlbumItemsData!.items!.length);

        Logger().d('next => ${event.nextUrl}');
        Logger().d(
            'length reached to total => ${oldAlbumItemsData.items!.length == oldAlbumItemsData.total}');

        if (event.nextUrl != 'null') {
          final moreAlbums =
              await spotifyRepository.getMoreRelease(event.nextUrl);

          if (moreAlbums!.items != null) {
            moreAlbums.items!.insertAll(0, oldAlbumItemsData.items!);
            userRepository.saveAlbumData(moreAlbums);
            emit(DashboardSuccessState(albumsData: moreAlbums));
          } else {
            emit(DashboardFailureState(
                errorMessage: 'Error fetching more data'));
          }
        }

        Logger().d("oldAlbumItemsData => ${oldAlbumItemsData.items!.length}");
      } catch (e) {
        print('error fetching more albums $e');
      }
    });

    on<OnDisplaySong>((event, emit) async {
      try {
        final videoId = await spotifyRepository.getVideoId(
            event.songName, event.artistName);

        if (videoId != null) {
          userRepository.saveCurrentSongId(videoId);
          emit(DashboardSuccessState(videoId: videoId));
        } else {
          emit(DashboardFailureState(errorMessage: 'Error fetching videoID'));
        }
      } catch (e) {
        print('error fetching video id');
      }
    });
    on<SignoutUser>((event, emit) async {
      emit(DashboardLoadingState(isLoading: true));
      try {
        firebaseRepository.signOut();
      } catch (e) {
        print('error');
        print(e.toString());
      }
      emit(DashboardLoadingState(isLoading: false));
    });
  }

  @override
  DashboardState? fromJson(Map<String, dynamic> json) {
    try {
      final userData =
          json['user'] != null ? UserModel.fromJson(json['user']) : null;

      if (userData != null) {
        userRepository.saveUserData(userData);
      }

      return DashboardSuccessState(currentUser: userData);
    } catch (e) {}
    return null;
  }

  @override
  Map<String, dynamic>? toJson(DashboardState state) {
    if (state is DashboardSuccessState) {
      final Map<String, dynamic> json = {};

      json['user'] = state.currentUser?.id!.isNotEmpty == true
          ? state.currentUser?.toJson()
          : userRepository.userDataModel;

      log('Saved state to JSON: ${json.keys}');

      return json;
    }
    return null;
  }
}
