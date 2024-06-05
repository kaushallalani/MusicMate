import 'package:musicmate/pages/home/index.dart';
import 'package:musicmate/pages/settings/index.dart';
import 'package:musicmate/pages/songsPage/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NAVIGATION {
  static const String songsPage = '/songsPage';
  static const String home = '/';
  static const String settings = '/settings';
}

List<Map<String, dynamic>> stackNavigation = [
  {
    "name": NAVIGATION.home,
    "component": (BuildContext context, GoRouterState state) =>
        const HomePage(),
    "options": {"path": NAVIGATION.home}
  },
  {
    "name": NAVIGATION.settings,
    "component": (BuildContext context, GoRouterState state) =>
        const SettingsPage(),
    "options": {"path": NAVIGATION.settings}
  },
  {
    "name": NAVIGATION.songsPage,
    "component": (BuildContext context, GoRouterState state) =>
        const SongsPage(),
    "options": {"path": NAVIGATION.songsPage}
  }
];
