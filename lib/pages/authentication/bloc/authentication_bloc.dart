import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/firebase_repository.dart';
import 'package:musicmate/repositories/user_repository.dart';
import 'package:musicmate/services/auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FirebaseRepository firebaseRepository;
  final UserRepository userRepository;

  final AuthenticationService authenticationService = AuthenticationService();
  AuthenticationBloc(this.firebaseRepository, this.userRepository)
      : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) {});

    on<SignupUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));

      try {
        final UserModel? user =
            await authenticationService.signupUser(event.email, event.password);

        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        print(e.toString());
      }

      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignoutUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        firebaseRepository.signOut();
      } catch (e) {
        print('error');
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
          emit(AuthenticationSuccessState(userRepository.userDataModel!));
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
        final user = await authenticationService.signInWithGoogle();

        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(AuthenticationFailureState('error'));
        }
      } on Exception catch (e) {
        emit(AuthenticationFailureState(e.toString()));
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
