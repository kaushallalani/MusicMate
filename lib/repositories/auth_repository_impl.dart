import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/auth_repository.dart';
import 'package:musicmate/services/auth_service.dart';
import 'package:musicmate/services/spotify_authentication.dart';
import 'package:unique_identifier/unique_identifier.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseService firebaseService = FirebaseService();
  final SpotifyAuthentication spotifyAuthentication = SpotifyAuthentication();

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final uid = await getCurrentUserId();
      final data = await firebaseService.userDetailsGet(id: uid);
      // spotifyAuthentication.fetchTracks();

      Logger().d(data.activeSessionId);
      return data;
    } on Exception catch (e) {
      print('Exception curentUserId => $e');
      return Future.error(e);
    }
  }

  @override
  Future<dynamic> getCurrentUserId() async {
    try {
      final data = await firebaseService.getCurrentUserId();
      return data;
    } on Exception catch (e) {
      print('Exception curentUserId => $e');
      return Future.error(e);
    }
  }

  @override
  Future<User?> googleSignInUser() async {
    try {
      final data = await firebaseService.signInWithGoogle();
      if (data != null) {
        if (data.additionalUserInfo!.isNewUser) {
          await GoogleSignIn().signOut();
          await FirebaseAuth.instance.currentUser!.delete();
        } else {
          final User? firebaseUser = data.user;
          final deviceId = await UniqueIdentifier.serial;
          UserModel? user = UserModel(
              deviceUniqueId: deviceId,
              updatedAt: FieldValue.serverTimestamp());
          Map<Object, Object?> updateData = user.toMapWithoutNulls();
          await firebaseService.updateUserDetail(
              id: firebaseUser!.uid, data: updateData);
          return firebaseUser;
        }
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print('Exception googleSignin => $e');
      return Future.error(e);
    }
    return null;
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final data = await firebaseService.signinUser(email, password);
      final User? firebaseUser = data!.user;
      final deviceId = await UniqueIdentifier.serial;
      UserModel? user = UserModel(
          deviceUniqueId: deviceId, updatedAt: FieldValue.serverTimestamp());
      Map<Object, Object?> updateData = user.toMapWithoutNulls();
      await firebaseService.updateUserDetail(
          id: firebaseUser!.uid, data: updateData);
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      print('Exception signin => $e');
      return Future.error(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseService.signOutUser();
    } on FirebaseAuthException catch (e) {
      print('Exception signout => $e');
    }
  }

  @override
  Future<User?> signUp(String email, String password, String name) async {
    try {
      final data = await firebaseService.signupUser(email, password, name);
      final User? firebaseUser = data!.user;
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      print('Exception signup => $e');
      return Future.error(e);
    }
  }

  @override
  Future<dynamic> googleSignUpUser() async {
    try {
      final data = await firebaseService.signUpWithGoogle();
      if (data != null) {
        if (data.additionalUserInfo!.isNewUser) {
          final User? user = data.user;
          await firebaseService.storeuserDetails(
              user!.uid, user.email, user.displayName);
          return true;
        } else {
          await firebaseService.signOutUser();
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Exception googleSignUp => $e");
      return Future.error(e);
    }
  }
}
