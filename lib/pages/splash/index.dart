import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musicmate/pages/dashboard/index.dart';
import 'package:musicmate/pages/login/index.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FirebaseAuth.instance.currentUser != null
            ? const Dashboard()
            : const LoginScreen());
  }
}
