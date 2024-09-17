import 'package:flutter/material.dart';

extension CustomTheme on ThemeData {
  CustomColors get customColors => CustomColors(brightness == Brightness.dark);
}

class CustomColors {
  static const Color lightCustomColor1 = Color(0xFF123456);
  static const Color lightCustomColor2 = Color(0xFF008AD3);
  static const Color lightCustomColor3 = Color(0xFF0F1234);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF818181);
  static const Color dimGray = Color(0xFF696969);
  static const Color red = Color(0xFFFF0000);
  static const Color casper = Color(0xFFABB3BB);
  static const Color toryBlue = Color(0xFF2F3990);
  static const Color solitude = Color(0xFFDFE1E6);
  static const Color solitudeShade1 = Color(0xFFF4F5F7);
  static const Color lightSlateBlue = Color(0xFF8591F9);
  static const Color headerBorderGrey = Color(0xFFDEDEDE);
  static const Color aquaBlue = Color(0xFFB4E2FF);
  static const Color silver = Color(0xFFb3b3b3);
  static const Color hintGray = Color(0xFFB3B3B3);
  static const Color green = Color(0xFF47D78A);
  static const Color companyGrey = Color.fromARGB(80, 192, 192, 192);
  static const Color orange = Color(0xFFF7471C);
  static const Color quartz = Color(0xFF4B4B4B);
  static const Color charcoal = Color(0xFF494949);
  static const Color whiteSmoke = Color(0xFFF0F0F0);
  static const Color orangePeel = Color(0xFFFF9600);
  static const Color eclipse = Color(0xFF3A3A3A);
  static const Color suvaGrey = Color(0xFF959595);
  static const Color lightBlue = Color(0xffDBF1FF);
  static const Color disabledGrey = Color(0xffF4F5F7);
  static const Color lightToryBlue = Color(0xffECEDF8);
  static const Color dividerGrey = Color(0xffEBECEF);
  static const Color lightGrey = Color(0xFFD3D3D3);
  static const Color wildSand = Color(0xFFEFECE8);
  static const Color lightEmerald = Color(0xFF4ED164);
  static const Color gainsBoro = Color(0xFFE5E5E5);

  static const Color darkCustomColor1 = Color(0xFF654321);
  static const Color darkCustomColor2 = Color(0xFF008AD3);
  static const Color darkCustomColor3 = Color(0xFF1A2345);
  static const Color black = Colors.black;
  static const Color darkGrey = Color(0xFF808080);
  static const Color darkRed = Color(0xFFFF0000);
  static const Color darkCasper = Color(0xFFABB3BB);
  static const Color darkDimGray = Color(0xFF706F6F);
  static const Color darkToryBlue = Color(0xFF2F3990);
  static const Color darkSolitude = Color(0xFFDFE1E6);
  static const Color darkLightSlateBlue = Color(0xFF8591F9);
  static const Color darkHeaderBorder = Color(0xFFDEDEDE);
  static const Color darkAquaBlue = Color.fromARGB(255, 154, 214, 252);
  static const Color darkSilver = Color(0xFFb3b3b3);
  static const Color darkHintGray = Color(0xFFB3B3B3);
  static const Color darkCompanyGrey = Color.fromARGB(96, 244, 245, 247);
  static const Color darkOrange = Color(0xFFF7471C);
  static const Color darkQuartz = Color(0xFF4B4B4B);
  static const Color darkCharcoal = Color(0xFF494949);
  static const Color darkWhiteSmoke = Color(0xFF36373B);
  static const Color darkOrangePeel = Color(0xFFFF9600);
  static const Color darkEclipse = Color(0xFF3A3A3A);
  static const Color darkSuvaGrey = Color(0xFF959595);
  static const Color darkLightBlue = Color(0xffA8DDFF);
  static const Color darkLightToryBlue = Color(0xffC6CAED);
  static const Color darkLightGrey = Color(0xFFD3D3D3);
  static const Color darkWildSand = Color(0xFFEFECE8);
  static const Color darkEmerald = Color(0xFF4ED164);
  static const Color darkGainsBoro = Color(0xFFE5E5E5);
    static const List<Color> blueGradientList = [
    Color(0xff39B5DB),
    Color(0xff319DCC),
    Color(0xff1F77B7),
    Color(0xff1255A4)
  ];

  final bool isDarkMode;

  CustomColors(this.isDarkMode);

  Color get customColor1 => isDarkMode ? darkCustomColor1 : lightCustomColor1;
  Color get customColor2 => isDarkMode ? darkCustomColor2 : lightCustomColor2;
  Color get customColor3 => isDarkMode ? darkCustomColor3 : lightCustomColor3;
  Color get bg => isDarkMode ? black : white;
  Color get bgInverse => isDarkMode ? white : black;
  Color get whiteColor => isDarkMode ? black : white;
  Color get blackColor => isDarkMode ? white : black;
  Color get greyColor => isDarkMode ? darkGrey : grey;
  Color get redColor => isDarkMode ? darkRed : red;
  Color get placeholderIcon => isDarkMode ? darkCasper : casper;
  Color get placeholder => isDarkMode ? darkSilver : silver;
  Color get dimGrey => isDarkMode ? darkDimGray : dimGray;
  Color get toryblue => isDarkMode ? darkToryBlue : toryBlue;
  Color get borderColor => isDarkMode ? darkGrey : solitude;
  Color get slateBlue => isDarkMode ? darkLightSlateBlue : lightSlateBlue;
  Color get checkboxBorder => isDarkMode ? dimGray : toryBlue;
  Color get orangeLabel => isDarkMode ? darkOrange : orange;
  Color get defaultWhite => white;
  Color get defaultBlack => black;
  Color get headerBorder => isDarkMode ? darkHeaderBorder : headerBorderGrey;
  Color get aquablueColor => isDarkMode ? darkAquaBlue : aquaBlue;
  Color get solitudeColor => isDarkMode ? darkSolitude : solitudeShade1;
  Color get greenColor => isDarkMode ? green : green;
  Color get companyColor => isDarkMode ? darkHeaderBorder : companyGrey;
  Color get orangeColor => isDarkMode ? darkOrange : orange;
  Color get quartzColor => isDarkMode ? darkQuartz : quartz;
  Color get charcoalText => isDarkMode ? darkCharcoal : charcoal;
  Color get whitesmoke => isDarkMode ? darkWhiteSmoke : whiteSmoke;
  Color get orangepeel => isDarkMode ? darkOrangePeel : orangePeel;
  Color get textColor => isDarkMode ? white : eclipse;
  Color get suvagrey => isDarkMode ? darkSuvaGrey : suvaGrey;
  Color get lightBlueColor => isDarkMode ? darkLightBlue : lightBlue;
  Color get disabledColor => isDarkMode ? quartz : disabledGrey;
  Color get lightTory => isDarkMode ? darkLightToryBlue : lightToryBlue;
  Color get dividerColor => isDarkMode ? dividerGrey : dividerGrey;
  Color get hintGreyColor => isDarkMode ? darkHintGray : hintGray;
  Color get wildsand => isDarkMode ? darkWildSand : wildSand;
  Color get lightgrey => isDarkMode ? darkLightGrey : lightGrey;
  Color get emerald => isDarkMode ? darkEmerald : lightEmerald;
  Color get gainsboro => isDarkMode ? darkGainsBoro : gainsBoro;
  List<Color> get blueGradient => blueGradientList;
  Brightness get iconBrightness =>
      isDarkMode ? Brightness.light : Brightness.dark;
}
