part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {
  final UserModel? currentUser;

  DashboardInitial({this.currentUser});
  List<Object?> get props => [currentUser];
}

class DashboardLoadingState extends DashboardInitial {
  final bool isLoading;
  DashboardLoadingState({required this.isLoading});
}

class DashboardSuccessState extends DashboardInitial {


  DashboardSuccessState({super.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class DashboardFailureState extends DashboardInitial {
  final String? errorMessage;

  DashboardFailureState({required this.errorMessage});
  @override
  List<Object?> get props => [];
}
