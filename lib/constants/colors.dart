import 'package:flutter/material.dart';

//  static const Color
class AppColor {
  AppColor._();

  static const blue = Color(0xffB0DDFF);
  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);

  static const List<Color> blueGradient = [
    Color(0xff39B5DB),
    Color(0xff319DCC),
    Color(0xff1F77B7),
    Color(0xff1255A4)
  ];
  static const trasparent = Color(0x00000000);
  static const headerBorder = Color(0xffDEDEDE);
  static const aquaBlue = Color(0xff199FDC);
  static const grey = Color(0xff808080);
}

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
);

ThemeData darkMode = ThemeData(brightness: Brightness.dark);
