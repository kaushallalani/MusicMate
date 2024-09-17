part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {
  final bool isLoading;
  AuthenticationLoadingState({required this.isLoading});
}

class AuthenticationSuccessState extends AuthenticationState {
  final UserModel? user;
  final String? authToken;
  AuthenticationSuccessState({this.user, this.authToken});
  @override
  List<Object> get props => [user!];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  AuthenticationFailureState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class AuthenticationSignUpSuccessState extends AuthenticationState {
  final UserModel? user;
  AuthenticationSignUpSuccessState(this.user);
  @override
  List<Object> get props => [user!];
}

class AuthenticationSignUpFailureState extends AuthenticationState {
  final String errorMessage;

  AuthenticationSignUpFailureState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
