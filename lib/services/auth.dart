import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicmate/models/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///create a user
  Future<UserModel?> signupUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(id: firebaseUser.uid, email: firebaseUser.email!);
      }
    } on FirebaseException catch (e) {
      print(e.toString());
    }
    return null;
  }

  ///signOutUser
  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  ///signin User
  Future<UserModel?> signinUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(id: firebaseUser.uid, email: firebaseUser.email!);
      }
    } on FirebaseException catch (e) {
      print('loginn error');
      print(e.message);
      return Future.error(e);
    }

    return null;
  }
}
