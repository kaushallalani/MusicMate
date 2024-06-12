import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/models/user.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///create a user
  Future<UserCredential?> signupUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      return userCredential;
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
  Future<UserCredential?> signinUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      return userCredential;
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
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

          return response;
      // if (response.additionalUserInfo!.isNewUser) {
      //   await GoogleSignIn().signOut();
      //   await FirebaseAuth.instance.currentUser!.delete();
      //   return;
      // } else {
      //   final User? firebaseUser = response.user;
      //   final UserModel? userDetail =
      //       await userDetailsGet(id: firebaseUser!.uid);
      //   return userDetail!;
      // }
    } on Exception catch (e) {
      print('exception->$e');
     
    }
  }

  Future<dynamic> getCurrentUserId() async {
    try {
      print('called');
      final uid = await _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        return uid;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel> userDetailsGet({required String id}) async {
    try {
      final document =
          await FirebaseFirestore.instance.collection("users").doc('$id');
      final snapshot = await document.get();
      final data = snapshot.data();
      final transformedData = transformData(data!);
      final jsonData = UserModel.fromJson(transformedData);

      // final finalData = data!.map((key, value) {
      //   if (value is Timestamp) {
      //     return MapEntry(
      //         key,
      //         value
      //             .toDate()
      //             .toString()); // Convert to DateTime and then to String
      //   } else {
      //     return MapEntry(key, value);
      //   }
      // });

      return jsonData;
      // final SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setString('user', jsonEncode(finalData));
      // await prefs.setBool('isLogin', true);
    } catch (e) {
      return Future.error(e);
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
}
