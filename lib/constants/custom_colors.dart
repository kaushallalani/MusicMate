import 'package:flutter/material.dart';

extension CustomTheme on ThemeData {
  CustomColors get customColors => CustomColors(brightness == Brightness.dark);
}

class CustomColors {
  static const Color lightCustomColor1 = Color(0xFF123456);
  static const Color lightCustomColor2 = Color(0xFFabcdef);
  static const Color lightCustomColor3 = Color(0xFF0F1234);
  static const Color white = Colors.white;

  static const Color darkCustomColor1 = Color(0xFF654321);
  static const Color darkCustomColor2 = Color(0xFFfedcba);
  static const Color darkCustomColor3 = Color(0xFF1A2345);
  static const Color black = Colors.black;

  final bool isDarkMode;

  CustomColors(this.isDarkMode);

  Color get customColor1 => isDarkMode ? darkCustomColor1 : lightCustomColor1;
  Color get customColor2 => isDarkMode ? darkCustomColor2 : lightCustomColor2;
  Color get customColor3 => isDarkMode ? darkCustomColor3 : lightCustomColor3;
  Color get bg => isDarkMode ? black : white;
  Color get bgInverse => isDarkMode ? white : black;

  Brightness get iconBrightness =>
      isDarkMode ? Brightness.light : Brightness.dark;
}
