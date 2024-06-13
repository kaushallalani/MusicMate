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
  AuthenticationSuccessState(this.user);
  @override
  List<Object> get props => [user!];
}

class AuthenticationFailureState extends AuthenticationState {
  final String errorMessage;

  AuthenticationFailureState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
