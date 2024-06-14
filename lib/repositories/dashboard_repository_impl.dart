import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final FirebaseFirestore firebaseFirestore;

  DashboardRepositoryImpl({required this.firebaseFirestore});

  final CollectionReference sessionsCollection =
      FirebaseFirestore.instance.collection('sessions');

  @override
  Future<String> createSession(SessionModel? session) async {
    try {
      final sessionData = await sessionsCollection.add(session!.toJson());

      return sessionData.id;
    } on FirebaseException catch (e) {
      print('Exception create session => $e');
      return Future.error(e);
    }
  }

  @override
  Future<SessionModel?> fetchCurrentSessionDetails(String id) async {
    try {
      final DocumentSnapshot sessionSnapshot =
          await sessionsCollection.doc(id).get();
      if (sessionSnapshot.data() != null) {
        final jsonData = sessionSnapshot.data() as Map<String, dynamic>;
        return SessionModel.fromJson(jsonData);
      }

      return null;
    } on FirebaseException catch (e) {
      print('Exception fetch session => $e');
      return Future.error(e);
    }
  }

  @override
  Future<SessionModel?> fetchDataFromSession(String id, Query query) async {
    try {
      final sessionDetails = await sessionsCollection.get();
    } on FirebaseException catch (e) {
      print('Exception fetch data session => $e');
      return Future.error(e);
    }
  }

  @override
  Future<List<SessionModel?>> fetchAllUserSessions(String id) async {
    try {
      final QuerySnapshot querySnapshot =
          await sessionsCollection.where('allUsers', arrayContains: id).get();

      List<SessionModel> sessions = querySnapshot.docs.map((doc) {
        return SessionModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      Logger().d(sessions);
      return sessions;
    } on FirebaseException catch (e) {
      print('Exception fetch data session => $e');
      return Future.error(e);
    }
  }
}
