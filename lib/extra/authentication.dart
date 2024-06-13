import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final log = Logger();

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error Ocurred";
    try {
      log.d(email.isNotEmpty);
      if (email.isNotEmpty && password.isNotEmpty) {
        log.d(await _auth.signInWithEmailAndPassword(
            email: email, password: password));
        var user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        var status = await userDetailsGet(id: user.user!.uid);
        print("status $status");
        if (status == "Success") {
          res = "Success";
        } else {
          res = "User Data not found.";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<dynamic> signInWithGoogle() async {
    String res = "Some error Ocurred";
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        var response = await _auth.signInWithCredential(credential);
        print("RESPONSEEE $response");
        if (response.additionalUserInfo!.isNewUser) {
          res = "user not exist";
          await GoogleSignIn().signOut();
          await _auth.currentUser?.delete();
          await signOut();
        } else {
          res = "Success";
        }
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  signOut() async {
    if (_auth.currentUser?.providerData[0].providerId == 'google.com') {
      await GoogleSignIn().signOut();
    }
    await _auth.signOut();
  }

  Future<dynamic> userDetailsGet({required String id}) async {
    String res = "Some Error Ocurred";
    try {
      final document = _firestore.collection("users").doc(id);
      final snapshot = await document.get();
      final data = snapshot.data();
      print("user details");
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', jsonEncode(finalData));
      await prefs.setBool('isLogin', true);
      res = "Success";
    } catch (e) {
      return e.toString();
    }
    return res;
  }
}
