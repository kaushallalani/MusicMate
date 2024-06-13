// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/pages/settings/index.dart';
import 'package:flutter/material.dart';

import '../pages/authentication/bloc/authentication_bloc.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // logo
          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.music_note,
                size: 40,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // home title
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: const Text('H O M E'),
              leading: const Icon(Icons.home),
              onTap: () => Navigator.pop(context),
            ),
          ),

          // settings tile
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 0),
            child: ListTile(
              title: const Text('S E T T I N G S'),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),

          // logout title
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 0),
            child: ListTile(
              title: const Text('L O G O U T'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                BlocProvider.of<AuthenticationBloc>(context).add(SignoutUser());
                context.go(NAVIGATION.login);

                // await AuthServices().signOut();
                // final SharedPreferences prefs =
                //     await SharedPreferences.getInstance();
                // await prefs.setBool("isLogin", false);
                // await prefs.remove("user");
                // context.(NAVIGATION.login);
              },
            ),
          )
        ],
      ),
    );
  }
}
