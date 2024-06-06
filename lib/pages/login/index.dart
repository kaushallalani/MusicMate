import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/snackbar.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: 'dhanraj@malinator.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'Abc@223133');

  bool isLoading = false;
  bool passwordVisible = false;
  final log = Logger();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (isLoading == false) {
    //   context.push(NAVIGATION.dashboard);
    // }
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () async {
      String res = await AuthServices().loginUser(
          email: _emailController.text, password: _passwordController.text);

      log.d(res);
      if (res == "Success") {
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });

        // showSnackBar(context, res);
      }

      context.push(NAVIGATION.dashboard);
    });
  }

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
                  width: MediaQuery.of(context).size.width / 2,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
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
                ElevatedButton(
                  onPressed: loginUser,
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: const Divider(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: const Center(child: Text("Or")),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: const Divider(),
                    ),
                  ],
                ),
                Center(
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width * 0.07,
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
  }
}
