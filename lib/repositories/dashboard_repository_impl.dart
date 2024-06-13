import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final FirebaseFirestore firebaseFirestore;

  DashboardRepositoryImpl({required this.firebaseFirestore});

  @override
  void createSession(String name) {
    final CollectionReference sessionsCollection =
        FirebaseFirestore.instance.collection('sessions');
    try {
      final sessionData = sessionsCollection.add(SessionModel(
          id: '',
          sessionName: name,
          currentSongId: '',
          allUsers: [],
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString()));
    } on FirebaseException catch (e) {}
  }

  @override
  Future<SessionModel?> fetchSessionDetails(String id) {
    // TODO: implement fetchSessionDetails
    throw UnimplementedError();
  }
}
