import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/snackbar.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/pages/authentication/bloc/authentication_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameConroller = TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;
  final log = Logger();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameConroller.dispose();
  }

  void registerUser() async {
    if (_emailController.text.isEmpty &&
        _passwordController.text.isEmpty &&
        _nameConroller.text.isEmpty) {
      showSnackBar(context, 'Fields cannot be empty');
    } else {
      BlocProvider.of<AuthenticationBloc>(context).add(SignupUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameConroller.text));
    }
  }

  void signupWithGoogle() async {
    BlocProvider.of<AuthenticationBloc>(context).add(const GoogleSignUp());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSignUpSuccessState) {
          context.push(NAVIGATION.dashboard);
        } else if (state is AuthenticationLoadingState) {
          setState(() {
            isLoading = state.isLoading;
          });
        } else if (state is AuthenticationSignUpFailureState) {
          showSnackBar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Sign Up',
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
                        controller: _nameConroller,
                        decoration:
                            const InputDecoration(hintText: 'Full Name'),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
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
                        onPressed: registerUser,
                        child: const Text(
                          'Register',
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
                        onPressed: signupWithGoogle,
                        child: Image.asset(
                          'assets/images/google.png',
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.09,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: Metrics.doubleBaseMargin,
                          bottom: Metrics.doubleBaseMargin),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account ?'),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: GestureDetector(
                              child: const Text('Sign In',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              onTap: () => context.pop(),
                            ),
                          ),
                        ],
                      ),
                    )
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
