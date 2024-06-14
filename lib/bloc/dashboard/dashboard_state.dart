part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {
  final UserModel? currentUser;
  final SessionModel? sessionData;

  DashboardInitial({
    this.currentUser,
    this.sessionData
  });
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

class SessionSuccessState extends DashboardInitial {
  final String? sessionId;
  final SessionModel? sessionData;
  final List<SessionModel?> userSessions;

  SessionSuccessState(
      {super.currentUser,
      required this.sessionId,
      required this.sessionData,
      required this.userSessions});
  @override
  List<Object?> get props => [currentUser, sessionId, sessionData];
}

class SessionErrorState extends DashboardInitial {
  final String? errorMessage;

  SessionErrorState({super.currentUser, required this.errorMessage});

  @override
  List<Object?> get props => [];
}
