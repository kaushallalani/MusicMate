import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicmate/models/user.dart';

abstract class FirebaseRepository {
  Future<UserModel?> getCurrentUser();
  Future<User?> signUp(String email, String password, String name);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
  Future<User?> googleSignInUser();
  Future<dynamic> getCurrentUserId();
  Future<dynamic> googleSignUpUser();
}
