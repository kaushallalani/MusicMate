import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/snackbar.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/pages/authentication/bloc/authentication_bloc.dart';
import 'package:musicmate/services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'Test@223133');

  bool isLoading = false;
  bool passwordVisible = false;
  final log = Logger();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    BlocProvider.of<AuthenticationBloc>(context).add(SigninUser(
        email: _emailController.text, password: _passwordController.text));
  }
  // void loginUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   Future.delayed(const Duration(seconds: 1), () async {
  //     String res = await AuthServices().loginUser(
  //         email: _emailController.text, password: _passwordController.text);

  //     log.d(res);
  //     if (res == "Success") {
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });

  //       // showSnackBar(context, res);
  //     }

  //     context.push(NAVIGATION.dashboard);
  //   });
  // }

  void signInWithGoogle() async {
    setState(() {
      isLoading == true;
    });

    Future.delayed(const Duration(seconds: 1), () async {
      String res = await AuthServices().signInWithGoogle();
      if (res == "Success") {
        context.push(NAVIGATION.dashboard);
      } else {
        showSnackBar(context, res);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccessState) {
          setState(() {
            isLoading = false;
          });
          context.push(NAVIGATION.dashboard);
        } else if (state is AuthenticationLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else if (state is AuthenticationFailureState) {
          showSnackBar(context, state.errorMessage);
          setState(() {
            isLoading = false;
          });
        }
      },
      builder: (context, state) {
       
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: Metrics.width(context) * 0.85,
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(hintText: 'Email'),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: Metrics.width(context) * 0.85,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !passwordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: Metrics.width(context) * 0.85,
                      child: ElevatedButton(
                        onPressed: loginUser,
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: const Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: const Center(child: Text("Or")),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: const Divider(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.07,
                        padding: const EdgeInsets.only(
                            top: Metrics.doubleBaseMargin),
                        onPressed: signInWithGoogle,
                        child: Image.asset(
                          'assets/images/google.png',
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.09,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
