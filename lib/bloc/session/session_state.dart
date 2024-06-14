part of 'session_bloc.dart';

@immutable
abstract class SessionState {}

class SessionInitial extends SessionState {
  final SessionModel? sessionModel;

  SessionInitial({this.sessionModel});
  List<Object?> get props => [];
}

class SessionLoading extends SessionInitial {
  final bool isLoading;

  SessionLoading({super.sessionModel, required this.isLoading});
  @override
  List<Object?> get props => [isLoading];
}

class SessionSuccessState extends SessionInitial {
  final SessionModel? sessionData;

  SessionSuccessState({super.sessionModel, required this.sessionData});
  @override
  List<Object?> get props => [sessionData];
}

class SessionErrorState extends SessionInitial {
  final String? errorMessage;

  SessionErrorState({super.sessionModel, required this.errorMessage});

  @override
  List<Object?> get props => [];
}
