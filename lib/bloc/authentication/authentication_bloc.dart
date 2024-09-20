import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:musicmate/models/index.dart';
import 'package:musicmate/repositories/index.dart';
import 'package:musicmate/services/global_listeners.dart';
import 'package:musicmate/services/spotify_authentication.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseRepository firebaseRepository;
  final UserRepository userRepository;
  final SpotifyAuthentication spotifyAuthentication;

  AuthenticationBloc(
      this.firebaseRepository, this.userRepository, this.spotifyAuthentication)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignupUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));

      try {
        final User? user = await firebaseRepository.signUp(
            event.email, event.password, event.name);

        if (user != null) {
          add(GenerateSpotifyAccessToken());
          // emit(AuthenticationSuccessState(user: userRepository.userDataModel));
        } else {
          emit(AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }

      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SigninUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));

      try {
        final User? user =
            await firebaseRepository.signIn(event.email, event.password);
        if (user != null) {
          add(GenerateSpotifyAccessToken());
          // final accessToken = await spotifyAuthentication.getAccessToken();
          // if (accessToken != null) {
          //   log('tokeeenn =>$accessToken');

          //   userRepository.saveAccessToken(
          //       accessToken, DateTime.now().add(const Duration(hours: 1)));
          //   GlobalListeners().setAuthToken(accessToken);
          //   userRepository.saveUserLoginStatus(true);
          //   emit(
          //       AuthenticationSuccessState(user: userRepository.userDataModel));
          // } else {
          //   userRepository.saveUserLoginStatus(false);
          //   emit(AuthenticationFailureState('Error while Logging in'));
          // }

          //   final data = await firebaseRepository.getCurrentUser();
          //   userRepository.saveUserData(data!);
        }
        // await authenticationService.signinUser(event.email, event.password);

        // if (user != null) {
        //   emit(AuthenticationSuccessState(userRepository.userDataModel));
        // }
        else {
          emit(AuthenticationFailureState('User Signin failed'));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthenticationFailureState(e.message!));
      }

      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<GoogleSignIn>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final User? user = await firebaseRepository.googleSignInUser();

        if (user != null) {
          add(GenerateSpotifyAccessToken());
          // emit(AuthenticationSuccessState(user: userRepository.userDataModel));
        } else {
          emit(AuthenticationFailureState(
              'Please register your google account'));
        }
      } on Exception catch (e) {
        emit(AuthenticationFailureState(e.toString()));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<GoogleSignUp>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final dynamic user = await firebaseRepository.googleSignUpUser();

        if (user == true) {
          add(GenerateSpotifyAccessToken());
          // emit(AuthenticationSignUpSuccessState(userRepository.userDataModel));
        } else if (user == false) {
          emit(AuthenticationSignUpFailureState("User already exist"));
        } else {
          emit(AuthenticationSignUpFailureState("Please select an account"));
        }
      } on Exception catch (e) {
        emit(AuthenticationSignUpFailureState(e.toString()));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<GenerateSpotifyAccessToken>((event, emit) async {
      try {
        final accessToken = await spotifyAuthentication.getAccessToken();
        if (accessToken != null) {
          log('tokeeenn =>$accessToken');

          userRepository.saveAccessToken(
              accessToken, DateTime.now().add(const Duration(hours: 1)));
          GlobalListeners().setAuthToken(accessToken);
          userRepository.saveUserLoginStatus(true);
          emit(AuthenticationSuccessState(
              user: userRepository.userDataModel, loginStatus: true));
        } else {
          userRepository.saveUserLoginStatus(false);
          emit(AuthenticationFailureState('Error while Logging in'));
        }
        emit(AuthenticationLoadingState(isLoading: false));
      } catch (e) {}
    });
    on<GetLogginStatus>((event, emit) {
      emit(AuthenticationLoadingState(isLoading: true));
      log('calleldddd');
      if (userRepository.loginStatus != null) {
        emit(
          AuthenticationSuccessState(loginStatus: userRepository.loginStatus),
        );
      }

      emit(AuthenticationLoadingState(isLoading: false));
    });
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    try {
      final authToken = json['authToken'] as String? ?? '';
      final loginStatus = json['loginStatus'] as bool ?? null;

      if (authToken.isNotEmpty) {
        userRepository.saveAccessToken(authToken, null);
      }

      if (loginStatus != null) {
        userRepository.saveUserLoginStatus(loginStatus);
      }

      return AuthenticationSuccessState(
          authToken: authToken, loginStatus: loginStatus);
    } catch (e) {}
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    if (state is AuthenticationSuccessState) {
      final json = <String, dynamic>{};
      json['authToken'] = state.authToken ?? userRepository.accessToken;
      json['loginStatus'] = state.loginStatus ?? userRepository.loginStatus;
      log('Saved state to JSON: ${json}');

      return json;
    }
    return null;
  }
}
