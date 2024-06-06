// ignore_for_file: deprecated_member_use

import 'package:demo/pages/login/index.dart';
import 'package:musicmate/pages/settings/index.dart';
import 'package:demo/services/authentication.dart';
import 'package:flutter/material.dart';

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
                await AuthServices().signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
            ),
          )
        ],
      ),
    );
  }
}
