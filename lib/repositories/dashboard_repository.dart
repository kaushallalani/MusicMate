import 'package:musicmate/models/session.dart';

abstract class DashboardRepository {
 void createSession(String name);
  Future<SessionModel?> fetchSessionDetails(String id);
}
