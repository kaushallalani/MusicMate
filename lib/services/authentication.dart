import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error Ocurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
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
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        var response = await _auth.signInWithCredential(credential);
        print("RESPONSEEE $response");
        if (response.additionalUserInfo!.isNewUser) {
          res = "user not exist";
          await GoogleSignIn().signOut();
          await _auth.currentUser?.delete();
          // await signOut();
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
}
