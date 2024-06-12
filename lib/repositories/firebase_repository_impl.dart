import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/repositories/firebase_repository.dart';
import 'package:musicmate/services/firebase_service.dart';

class FirebaseRepositoryImpl extends FirebaseRepository {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final uid = await getCurrentUserId();
      final data = await firebaseService.userDetailsGet(id: uid);
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
      if (data!.additionalUserInfo!.isNewUser) {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.currentUser!.delete();
      } else {
        final User? firebaseUser = data.user;
        return firebaseUser;
      }
    } on FirebaseAuthException catch (e) {
      print('Exception googleSignin => ${e}');
      return Future.error(e);
    }
    return null;
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final data = await firebaseService.signinUser(email, password);
      final User? firebaseUser = data!.user;
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      print('Exception signin => ${e}');
      return Future.error(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseService.signOutUser();
    } on FirebaseAuthException catch (e) {
      print('Exception signout => ${e}');
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      final data = await firebaseService.signupUser(email, password);
      final User? firebaseUser = data!.user;
      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      print('Exception signup => ${e}');
      return Future.error(e);
    }
  }
}
