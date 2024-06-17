part of 'session_bloc.dart';

@immutable
abstract class SessionEvent {}

class FetchCurrentSession extends SessionEvent {}

class FetchSessionUserDetails extends SessionEvent {
  final List<String> userIds;

  FetchSessionUserDetails(this.userIds);
}


