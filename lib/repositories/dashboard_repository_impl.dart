import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/controllers/dio.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/dashboard_repository.dart';
import 'package:musicmate/repositories/user_repository.dart';
import 'package:musicmate/services/spotify_authentication.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final FirebaseFirestore firebaseFirestore;
  final SpotifyAuthentication spotifyAuthentication;
  final UserRepository userRepository;

  DashboardRepositoryImpl(this.spotifyAuthentication, this.userRepository,
      {required this.firebaseFirestore});

  final CollectionReference sessionsCollection =
      FirebaseFirestore.instance.collection('sessions');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  Future<String> createSession(SessionModel? session) async {
    try {
      final sessionData = await sessionsCollection.add(session!.toJson());

      await sessionData.update({'id': sessionData.id});
      changeActiveUserSession(session.ownerId!, sessionData.id);
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
    return null;
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

  @override
  Future<List<UserModel?>> fetchSessionUsers(List<String> userId) async {
    try {
      List<Future<DocumentSnapshot>> futures = userId.map((id) {
        return usersCollection.doc(id).get();
      }).toList();

      List<DocumentSnapshot> snapshots = await Future.wait(futures);

      // Convert DocumentSnapshot to UserModel using fromJson
      List<UserModel?> users = snapshots.map((doc) {
        if (doc.exists) {
          final transformedData =
              transformData(doc.data() as Map<String, dynamic>);
          return UserModel.fromJson(transformedData);
        } else {
          return null;
        }
      }).toList();

      return users;
    } on FirebaseException catch (e) {
      print('Error fetching user data: ${e.message}');
      return [];
    }
  }

  Map<String, dynamic> transformData(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toString());
      } else {
        return MapEntry(key, value);
      }
    });
  }

  @override
  Future<dynamic> joinSession(String code, String userId) async {
    try {
      final QuerySnapshot validSession = await sessionsCollection
          .where('sessionCode', isEqualTo: code)
          .limit(1)
          .get();
      if (validSession.docs.isNotEmpty) {
        final docData = validSession.docs.first;
        Logger().d(docData.id);

        final data =
            SessionModel.fromJson(docData.data() as Map<String, dynamic>);
        changeActiveUserSession(userId, docData.id);
        if (data.allUsers!.contains(userId)) {
        } else {
          updateSessionData(data, userId, docData.id);
        }
        return data;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> updateSessionData(
      SessionModel sessionData, String userId, String sessionId) async {
    try {
      final List<String> newUsers = sessionData.allUsers!;
      newUsers.add(userId);

      final updatedData = SessionModel(
          id: sessionId,
          sessionCode: sessionData.sessionCode,
          sessionName: sessionData.sessionName,
          allUsers: newUsers,
          ownerId: sessionData.ownerId,
          currentSongId: sessionData.currentSongId,
          createdAt: sessionData.createdAt,
          updatedAt: DateTime.now().toString());

      final isUpdated =
          await sessionsCollection.doc(sessionId).update(updatedData.toJson());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  Future<void> changeActiveUserSession(String userId, String sessionId) async {
    try {
      final userActiveSession = await usersCollection.doc(userId).update({
        'activeSessionId': sessionId,
        'updatedAt': DateTime.now().toString()
      });
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

 
}
