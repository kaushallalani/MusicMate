import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:musicmate/pages/dashboard/index.dart';
import 'package:musicmate/pages/home/index.dart';
import 'package:musicmate/pages/library/index.dart';
import 'package:musicmate/pages/listenTogether/index.dart';
import 'package:musicmate/pages/login/index.dart';
import 'package:musicmate/pages/playback/fragment.dart';
import 'package:musicmate/pages/search/index.dart';
import 'package:musicmate/pages/session/index.dart';
import 'package:musicmate/pages/settings/index.dart';
import 'package:musicmate/pages/signup/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musicmate/pages/splash/index.dart';

class NAVIGATION {
  static const String songsPage = '/songsPage';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String dashboard = '/dashboard';
  static const String search = '/search';
  static const String library = '/library';
  static const String login = '/login';
  static const String splash = '/';
  static const String listenTogether = '/listenTogether';
  static const String signup = '/signup';
  static const String session = '/session';
  static const String playback = '/playback';
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
  // {
  //   "name": NAVIGATION.songsPage,
  //   "component": (BuildContext context, GoRouterState state) =>
  //       const SongsPage(),
  //   "options": {"path": NAVIGATION.songsPage}
  // },
  {
    "name": NAVIGATION.dashboard,
    "component": (BuildContext context, GoRouterState state) =>
        const Dashboard(),
    "options": {"path": NAVIGATION.dashboard}
  },
  {
    "name": NAVIGATION.search,
    "component": (BuildContext context, GoRouterState state) => const Search(),
    "options": {"path": NAVIGATION.search}
  },
  {
    "name": NAVIGATION.library,
    "component": (BuildContext context, GoRouterState state) => const Library(),
    "options": {"path": NAVIGATION.library}
  },
  {
    "name": NAVIGATION.login,
    "component": (BuildContext context, GoRouterState state) =>
        const LoginScreen(),
    "options": {"path": NAVIGATION.login}
  },
  {
    "name": NAVIGATION.splash,
    "component": (BuildContext context, GoRouterState state) =>
        const SplashScreen(),
    "options": {"path": NAVIGATION.splash}
  },
  {
    "name": NAVIGATION.signup,
    "component": (BuildContext context, GoRouterState state) =>
        const SignupScreen(),
    "options": {"path": NAVIGATION.signup}
  },
  {
    "name": NAVIGATION.listenTogether,
    "component": (BuildContext context, GoRouterState state) => ListenTogether(
          id: state.uri.queryParameters['id']!,
        ),
    "options": {"path": NAVIGATION.listenTogether}
  },
  {
    "name": NAVIGATION.session,
    "component": (BuildContext context, GoRouterState state) => const Session(),
    "options": {"path": NAVIGATION.session}
  },
  {
    "name": NAVIGATION.playback,
    "component": (BuildContext context, GoRouterState state) {
      // final AlbumItem currentSong = AlbumItem.fromJson(
      //     jsonDecode(state.uri.queryParameters['currentSong']!));
      Logger().d('in nav currentS');
      return PlaybackFragment(
        currentSong: jsonDecode(
          state.uri.queryParameters['currentSong']!,
        ),
        currentSongType: state.uri.queryParameters['currentSongType']!,
      );
    },
    "options": {"path": NAVIGATION.playback}
  }
];
