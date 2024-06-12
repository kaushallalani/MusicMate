import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
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
        // return UserModel(id: firebaseUser.uid, email: firebaseUser.email!);
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
      final userDetail = await userDetailsGet(id: firebaseUser!.uid);
      if (firebaseUser != null) {
        Logger().d(userDetail["email"]);
        return UserModel(userDetail["fullName"], userDetail["createdAt"],
            userDetail["updatedAt"],
            id: firebaseUser.uid, email: userDetail["email"]);
      }
    } on FirebaseException catch (e) {
      print('loginn error');
      print(e.message);
      return Future.error(e);
    }

    return null;
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      var response =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (response.additionalUserInfo!.isNewUser) {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.currentUser!.delete();
        return;
      } else {
        final User? firebaseUser = response.user;
        final userDetail = await userDetailsGet(id: firebaseUser!.uid);
        return UserModel(userDetail["fullName"], userDetail["createdAt"],
            userDetail["updatedAt"],
            id: firebaseUser.uid, email: userDetail["email"]);
      }
    } on Exception catch (e) {
      print('exception->$e');
      return e.toString();
    }
  }

  Future<dynamic> userDetailsGet({required String id}) async {
    try {
      final document =
          await FirebaseFirestore.instance.collection("users").doc('$id');
      final snapshot = await document.get();
      final data = snapshot.data();
      print("objectfsdfdsff");
      print(data);
      final finalData = data!.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(
              key,
              value
                  .toDate()
                  .toString()); // Convert to DateTime and then to String
        } else {
          return MapEntry(key, value);
        }
      });
      return finalData;
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('user', jsonEncode(finalData));
      // await prefs.setBool('isLogin', true);
    } catch (e) {
      return e.toString();
    }
  }
}
