import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/services/spotify_authentication.dart';

class GlobalListeners with WidgetsBindingObserver {
  static final GlobalListeners instance = GlobalListeners.internal();

  factory GlobalListeners() => instance;

  GlobalListeners.internal();
  final SpotifyAuthentication spotifyAuthentication = SpotifyAuthentication();
  String? authToken;
  Timer? timer;

  String? get AUTHTOKEN => authToken;
  void initializeAuthToken() {
    Logger().d('Listener initialise');
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> setAuthToken(String token) async {
    authToken = token;
    Logger().d('Token set =>$token');
    startExpirationTimer();
  }

  Future<void> regenerateAuthKey() async {
    try {
      final token = await spotifyAuthentication.getAccessToken();

      if (token != null) {
        Logger().d('Token regenerated');
        authToken = token;
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
