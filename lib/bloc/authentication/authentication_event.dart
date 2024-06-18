part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {
  const AuthenticationEvent();

  List<Object> get props => [];
}

class SignupUser extends AuthenticationEvent {
  final String email;
  final String password;
  final String name;

  const SignupUser(
      {required this.email, required this.password, required this.name});
  @override
  List<Object> get props => [email, password, name];
}

class SigninUser extends AuthenticationEvent {
  final String email;
  final String password;

  const SigninUser({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class GoogleSignIn extends AuthenticationEvent {
  const GoogleSignIn();
  @override
  List<Object> get props => [];
}

class GoogleSignUp extends AuthenticationEvent {
  const GoogleSignUp();
  @override
  List<Object> get props => [];
}

class SignoutUser extends AuthenticationEvent {}

