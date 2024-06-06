import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final String key = "theme";
  late SharedPreferences prefs;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme; //Getter

  ThemeProvider() {
    _darkTheme = false;
    loadFromPrefs();
  }

  toggleTheme() {
    print('in toggle');
    _darkTheme = !_darkTheme;
    saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    print(prefs);
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  loadFromPrefs() async {
    // await _initPrefs();
    prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(key) ?? false;
    notifyListeners();
  }

  saveToPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, darkTheme);
  }
}
