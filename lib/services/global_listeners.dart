import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/bloc/authentication/authentication_bloc.dart';
import 'package:musicmate/services/spotify_authentication.dart';
import '../repositories/index.dart';

class GlobalListeners with WidgetsBindingObserver {
  static final GlobalListeners instance = GlobalListeners.internal();

  factory GlobalListeners() => instance;

  GlobalListeners.internal();
  final SpotifyAuthentication spotifyAuthentication = SpotifyAuthentication();
  String? authToken;
  Timer? timer;
  BuildContext? context;

  String? get AUTHTOKEN => authToken;
  void initializeAuthToken(BuildContext context) {
    Logger().d('Listener initialise =>$context');

    WidgetsBinding.instance.addObserver(this);
    this.context = context;
  }

  Future<void> setAuthToken(String token) async {
    authToken = token;
    Logger().d('Token set =>$token');
    // BlocProvider.of<AuthenticationBloc>(context!)
    //     .add(OnSaveAuthToken(authToken: authToken));
    startExpirationTimer();
  }

  Future<void> regenerateAuthKey() async {
    try {
      final token = await spotifyAuthentication.getAccessToken();

      if (token != null) {
        Logger().d('Token regenerated => $token');
        authToken = token;
        UserRepository().saveAccessToken(
            token, DateTime.now().add(const Duration(hours: 1)));
        BlocProvider.of<AuthenticationBloc>(context!)
            .add(OnSaveAuthToken(authToken: authToken));
        startExpirationTimer();
      } else {
        throw Exception('Error fetching auth token');
      }
    } catch (e) {
      print('Error refreshing auth token');
    }
  }

  // Start a timer to expire the auth key after an hour
  void startExpirationTimer() {
    timer?.cancel();
    timer = Timer(Duration(hours: 1), () {
      authToken = null;
      regenerateAuthKey();
    });
  }

  // Called when the app state changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (authToken == null) {
        regenerateAuthKey();
      }
    }
  }

  void dispose() {
    timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}
