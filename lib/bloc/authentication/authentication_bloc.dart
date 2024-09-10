import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:musicmate/models/index.dart';
import 'package:musicmate/repositories/index.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseRepository firebaseRepository;
  final UserRepository userRepository;

  AuthenticationBloc(this.firebaseRepository, this.userRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignupUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));

      try {
        final User? user = await firebaseRepository.signUp(
            event.email, event.password, event.name);

        if (user != null) {
          emit(AuthenticationSuccessState(userRepository.userDataModel));
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
        // if (user != null) {
        //   final data = await firebaseRepository.getCurrentUser();
        //   userRepository.saveUserData(data!);
        // }
        // await authenticationService.signinUser(event.email, event.password);

        if (user != null) {
          emit(AuthenticationSuccessState(userRepository.userDataModel));
        } else {
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
          emit(AuthenticationSuccessState(userRepository.userDataModel));
        } else {
          emit(AuthenticationFailureState('Please select an account'));
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
          emit(AuthenticationSignUpSuccessState(userRepository.userDataModel));
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
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    try {} catch (e) {}
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    if (state is AuthenticationSuccessState) {
      final json = <String, dynamic>{};

      return json;
    }
  }
}
