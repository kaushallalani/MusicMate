import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:musicmate/models/user.dart';
import 'package:unique_identifier/unique_identifier.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///create a user
  Future<UserCredential?> signupUser(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      var user = userCredential.user;
      await storeuserDetails(user!.uid, email, name);
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
      if (firebaseUser.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().signOut();
      }
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
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        var response =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return response;
      } else {
        return null;
      }
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
    return null;
  }

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        var response =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return response;
      } else {
        return null;
      }
    } on Exception catch (e) {
      print('exception->$e');
    }
    return null;
  }

  Future<dynamic> getCurrentUserId() async {
    try {
      print('called');
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid != null) {
        return uid;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel> userDetailsGet({required String id}) async {
    try {
      final document = FirebaseFirestore.instance.collection("users").doc(id);
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

  Future<dynamic> storeuserDetails(id, email, name) async {
    try {
      final document = FirebaseFirestore.instance.collection("users").doc(id);
      final deviceId = await UniqueIdentifier.serial;
      final response = await document.set({
        "id": id,
        "email": email,
        "fullName": name,
        "deviceUniqueId": deviceId,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return response;
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
