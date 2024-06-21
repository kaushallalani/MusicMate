part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {
  List<Object> get props => [];
}

class GetUserDetails extends DashboardEvent {}

class FetchUserDataFromFirebase extends DashboardEvent {}

class CreateSession extends DashboardEvent {
  final SessionModel? sessionModel;

  CreateSession({required this.sessionModel});
}

class FetchCurrentSession extends DashboardEvent {
  final String? sessionId;

  FetchCurrentSession({required this.sessionId});
}

class FetchUserSessions extends DashboardEvent {
  final String id;
  FetchUserSessions({required this.id});
}

class GetSessionDetails extends DashboardEvent {}

class SetCurrentSession extends DashboardEvent {
  final SessionModel sessionModel;

  SetCurrentSession({required this.sessionModel});
}

class JoinSession extends DashboardEvent {
  final String code;
  final String userId;

  JoinSession(this.userId, {required this.code});
}

class GenerateAccessToken extends DashboardEvent {}

class GetToken extends DashboardEvent {}

class GetBrowseCategories extends DashboardEvent {}

class GetNewReleases extends DashboardEvent {}

class FetchMoreReleases extends DashboardEvent {
  final String nextUrl;

  FetchMoreReleases({required this.nextUrl});
}

class OnPlaySong extends DashboardEvent {
  final String songName;
  final List<String> artistName;

  OnPlaySong({required this.songName,required this.artistName});
}
