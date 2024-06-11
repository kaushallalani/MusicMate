import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musicmate/pages/dashboard/index.dart';
import 'package:musicmate/pages/home/index.dart';
import 'package:musicmate/pages/login/index.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        if(snapshot.hasData){
          return const Dashboard();
        }else{
          return const LoginScreen();
        }
      }),
    );
  }
}