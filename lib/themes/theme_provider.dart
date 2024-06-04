// import 'package:flutter/material.dart';
// import 'package:demo/themes/dark_mode.dart';
// import 'package:demo/themes/light_mode.dart';

// class ThemeProvider extends ChangeNotifier {
//   // Initially, lightMode
//   ThemeData _themeData = lightMode;

//   //get theme
//   ThemeData get themeData => _themeData;

//   // is dark mode
//   bool get isDarkMode => _themeData == darkMode;

//   //set theme

//   set themeData(ThemeData themeData) {
//     _themeData = themeData;

//     //Update UI
//     notifyListeners();
//   }

//   // toggle theme
//   void toggleTheme() {
//     if (_themeData == lightMode) {
//       themeData = darkMode;
//     } else {
//       themeData = lightMode;
//     }
//   }
// }

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
