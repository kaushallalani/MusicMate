import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/bloc/authentication/authentication_bloc.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/index.dart';
import 'package:musicmate/constants/utils.dart';
import 'package:musicmate/navigation/app_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'test@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'Test@223133');

  bool isLoading = false;
  bool passwordVisible = false;
  final log = Logger();
  final _formKey = GlobalKey<FormState>();
  FToast? fToast;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(SigninUser(
          email: _emailController.text, password: _passwordController.text));
    }
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
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthenticationBloc>(context).add(const GoogleSignIn());
    }
    // setState(() {
    //   isLoading == true;
    // });

    // Future.delayed(const Duration(seconds: 1), () async {
    //   String res = await AuthServices().signInWithGoogle();
    //   if (res == "Success") {
    //     context.push(NAVIGATION.dashboard);
    //   } else {
    //     showSnackBar(context, res);
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // });
  }

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSuccessState) {
          context.push(NAVIGATION.dashboard);
        } else if (state is AuthenticationLoadingState) {
          setState(() {
            isLoading = state.isLoading;
          });
        } else if (state is AuthenticationFailureState) {
          showCustomToast(
              context: context,
              fToast: fToast!,
              message: [state.errorMessage],
              backgroundColor: colors.blackColor);
          // showSnackbar(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        print(isLoading);
        return Scaffold(
          backgroundColor: colors.whiteColor,
          appBar: AppBar(
              toolbarHeight: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).customColors.bg,
                  statusBarIconBrightness:
                      Theme.of(context).customColors.iconBrightness)),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  color: Theme.of(context).customColors.bg,
                  // height: Metrics.height(context) * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Metrics.height(context) * 0.1,
                        child: Image.asset(
                          'assets/images/icon.png',
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.25,
                          // color: Theme.of(context).customColors.bgInverse,
                        ),
                      ),
                      SizedBox(
                        height: Metrics.height(context) * 0.05,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: FontSize.xlarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: Metrics.height(context) * 0.08,
                            child: Container(
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  text: 'If you need any support  ',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .customColors
                                          .bgInverse),
                                  children: const [
                                    TextSpan(
                                      text: 'Click Here',
                                      style: TextStyle(
                                        color: Color.fromRGBO(172, 38, 27, 1),
                                      ),
                                    ),
                                  ],
                                ),
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
                                          width: 0.5,
                                        ),
                                      ),
                                      hintText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email is required";
                                      } else if (!Regex.emailRegex
                                          .hasMatch(value)) {
                                        return "Email has invalid format";
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
                                          width: 0.5,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
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
                                      } else if (!Regex.passwordRegex
                                          .hasMatch(value)) {
                                        return "Password is invalid";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 50.0,
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
                                            color:
                                                Color.fromRGBO(172, 38, 27, 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    onPressed: loginUser,
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.medium,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: const Divider(
                                        color:
                                            Color.fromARGB(255, 202, 202, 202),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: const Center(
                                        child: Text(
                                          "Or",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: const Divider(
                                        color:
                                            Color.fromARGB(255, 202, 202, 202),
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: Metrics.doubleBaseMargin),
                                  child: InkWell(
                                    onTap: signInWithGoogle,
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                    ),
                                  ),
                                ),
                                // Center(
                                //   child: MaterialButton(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(
                                //       MediaQuery.of(context).size.width *
                                //           0.09,
                                //     )),
                                //     minWidth:
                                //         MediaQuery.of(context).size.width *
                                //             0.07,
                                //     // padding: const EdgeInsets.only(
                                //     //     top: Metrics.doubleBaseMargin),
                                //     onPressed: signInWithGoogle,
                                //     child: Image.asset(
                                //       'assets/images/google.png',
                                //       fit: BoxFit.contain,
                                //       width:
                                //           MediaQuery.of(context).size.width *
                                //               0.09,
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: Metrics.baseMargin),
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Not a Member ?  ',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .customColors
                                              .bgInverse),
                                      children: [
                                        TextSpan(
                                          text: 'Register Now',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context.push(NAVIGATION.signup);
                                            },
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(172, 38, 27, 1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  width: MediaQuery.of(context)
                      .size
                      .width, // Full width of the screen
                  height: MediaQuery.of(context)
                      .size
                      .height, // Full height of the screen
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
