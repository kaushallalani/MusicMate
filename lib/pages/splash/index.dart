import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:musicmate/bloc/index.dart';
import 'package:musicmate/constants/index.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/pages/dashboard/index.dart';
import 'package:musicmate/pages/login/index.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
        BlocProvider.of<AuthenticationBloc>(context).add(GetLogginStatus());

  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationLoadingState) {
          setState(() {
            isLoading = state.isLoading;
          });
        }

        if (state is AuthenticationSuccessState) {
          if (state.loginStatus == true) {
            context.go(NAVIGATION.dashboard);
          } else if (state.loginStatus == false) {
            context.go(NAVIGATION.login);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: Container(
          color: colors.whiteColor,
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: CircularProgressIndicator(
              color: colors.toryblue,
            ),
          ),
        )

            // FirebaseAuth.instance.currentUser != null
            //     ? const Dashboard()
            //     : const LoginScreen()
            );
      },
    );
  }
}
