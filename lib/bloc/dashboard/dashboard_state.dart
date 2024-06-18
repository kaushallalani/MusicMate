part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {
  final UserModel? currentUser;
  final SessionModel? sessionData;

  DashboardInitial({this.currentUser, this.sessionData});
  List<Object?> get props => [currentUser];
}

class DashboardLoadingState extends DashboardInitial {
  final bool isLoading;
  DashboardLoadingState({required this.isLoading});
}

class DashboardSuccessState extends DashboardInitial {
  DashboardSuccessState({super.currentUser});

  @override
  List<Object?> get props => [
        currentUser,
      ];
}

class DashboardFailureState extends DashboardInitial {
  final String? errorMessage;

  DashboardFailureState({required this.errorMessage});
  @override
  List<Object?> get props => [];
}

class SessionLoadingSuccessState extends DashboardInitial {
  final String? sessionId;
  final List<SessionModel?>? userSessions;

  SessionLoadingSuccessState(
      {super.currentUser,
      super.sessionData,
      required this.sessionId,
      this.userSessions});

  @override
  List<Object?> get props => [currentUser, sessionId, sessionData];
}

class SessionLoadingErrorState extends DashboardInitial {
  final String? errorMessage;

  SessionLoadingErrorState({super.currentUser, required this.errorMessage});

  @override
  List<Object?> get props => [];
}
