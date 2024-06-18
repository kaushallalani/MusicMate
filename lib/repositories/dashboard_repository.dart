import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';

abstract class DashboardRepository {
  Future<String> createSession(SessionModel? session);
  Future<SessionModel?> fetchCurrentSessionDetails(String id);
  Future<SessionModel?> fetchDataFromSession(String id, Query query);
  Future<List<SessionModel?>> fetchAllUserSessions(String id);
  Future<List<UserModel?>> fetchSessionUsers(List<String> userId);
  Future<dynamic> joinSession(String code, String userId);
  Future<void> updateSessionData(SessionModel sessionData, String userId, String sessionId);
  Future<void> changeActiveUserSession(String userId, String sessionId);
}
