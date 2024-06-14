part of 'session_bloc.dart';

@immutable
abstract class SessionEvent {}


class FetchCurrentSession extends SessionEvent{} 