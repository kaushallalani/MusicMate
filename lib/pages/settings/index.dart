

import 'package:musicmate/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    print(ThemeProvider().darkTheme);
    return Scaffold(
      appBar: AppBar(
        title: const Text('S E T T I N G S'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //dark mode
            const Text(
              "Dark Mode",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            //switch
            Consumer(builder:
                (BuildContext context, ThemeProvider provider, Widget? child) {
              print(provider.darkTheme);
              return CupertinoSwitch(
                value: provider.darkTheme,
                onChanged: (val) => provider.toggleTheme(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
