import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/snackbar.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/navigation/app_navigation.dart';

import 'package:musicmate/bloc/authentication/authentication_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameConroller = TextEditingController();

  bool isLoading = false;
  bool passwordVisible = false;
  final log = Logger();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameConroller.dispose();
  }

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(SignupUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameConroller.text));
    }
  }

  void signupWithGoogle() async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(const GoogleSignUp());
    }
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
              toolbarHeight: Metrics.height(context) * 0.1,
              scrolledUnderElevation: 0,
              title: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.25,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              leadingWidth: Metrics.width(context) * 0.2,
              leading: IconButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromRGBO(221, 220, 220, 0.432))),
                icon: Image.asset(
                  'assets/images/back_arrow.png',
                  width: Metrics.width(context) * 0.035,
                  height: Metrics.width(context) * 0.035,
                ),
                onPressed: () {
                  context.pop(context);
                },
                iconSize: Metrics.doubleBaseMargin,
              )),
          body: SingleChildScrollView(
            child: Container(
              height: Metrics.height(context) * 0.9,
              color: Colors.white,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: FontSize.xlarge,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: Metrics.height(context) * 0.08,
                          child: Container(
                            alignment: Alignment.center,
                            child: RichText(
                              text: const TextSpan(
                                  text: 'If you need any support ',
                                  style: TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: 'Click Here',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(172, 38, 27, 1)))
                                  ]),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                width: Metrics.width(context) * 0.85,
                                child: TextFormField(
                                  controller: _nameConroller,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 20, bottom: 20, left: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 117, 117, 117),
                                              width: 0.5)),
                                      hintText: 'Full Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Name is required";
                                    } else if (value.length < 3) {
                                      return "Name should be atleast 3 characters";
                                    } else if (value.length > 20) {
                                      return "Name cannot be more tahn 20 characters";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              SizedBox(
                                width: Metrics.width(context) * 0.85,
                                child: TextFormField(
                                  controller: _emailController,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 20, bottom: 20, left: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 117, 117, 117),
                                              width: 0.5)),
                                      hintText: 'Email'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email is required";
                                    } else if (Regex.emailRegex
                                            .hasMatch(value) ==
                                        false) {
                                      return "Email is invalid";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              SizedBox(
                                width: Metrics.width(context) * 0.85,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: !passwordVisible,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        top: 20, bottom: 20, left: 15),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 117, 117, 117),
                                            width: 0.5)),
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password is required";
                                    } else if (Regex.passwordRegex
                                            .hasMatch(value) ==
                                        false) {
                                      return "Password is invalid";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Metrics.height(context) * 0.05,
                        ),
                        SizedBox(
                          width: Metrics.width(context) * 0.85,
                          height: Metrics.width(context) * 0.15,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromRGBO(172, 38, 27, 1)),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        side: BorderSide(
                                            color: Color.fromRGBO(
                                                172, 38, 27, 1))))),
                            onPressed: registerUser,
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.medium),
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
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: const Divider(
                                color: Color.fromARGB(255, 202, 202, 202),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: const Center(
                                  child: Text(
                                "Or",
                                style: TextStyle(color: Colors.grey),
                              )),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: const Divider(
                                color: Color.fromARGB(255, 202, 202, 202),
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
                        SizedBox(
                          height: Metrics.width(context) * 0.2,
                          child: Container(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                    text: 'Already havce an account? ',
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: 'Sign In',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context.pop(context);
                                            },
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  172, 38, 27, 1),
                                              fontWeight: FontWeight.bold))
                                    ]),
                              )),
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
            ),
          ),
        );
      },
    );
  }
}
