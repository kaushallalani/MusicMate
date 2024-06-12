part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {
  List<Object> get props => [];
}

class GetUserDetails extends DashboardEvent {}

class FetchUserDataFromFirebase extends DashboardEvent{
  
}