import 'dart:developer' as dev;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class Metrics {
  Metrics._();

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static const double marginHorizontal = 10.0;
  static const double marginVertical = 10.0;
  static const double section = 25.0;
  static const double baseMargin = 10.0;
  static const double doubleBaseMargin = 20.0;
  static const double tripleBaseMargin = 30.0;
  static const double extraSmallMargin = 3.0;
  static const double smallMargin = 5.0;
  static const double doubleSection = 50.0;
  static const double horizontalLineHeight = 1.0;
  static const double semiBaseMargin = 15.0;
  static const double iconSize = 18.0;

  static double screenWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < size.height ? size.width : size.height;
  }

  static double screenHeight(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width < size.height ? size.height : size.width;
  }

  static double navBarHeight(BuildContext context) {
    return Platform.isIOS ? 64.0 : 54.0;
  }

  static const double buttonRadius = 4.0;
  static const double borderRadius = 5.0;
  static const double doubleButtonRadius = 8.0;
  static const double doubleBorderRadius = 10.0;

  static const icons = {
    'tiny': 15.0,
    'small': 20.0,
    'medium': 30.0,
    'large': 45.0,
    'xl': 50.0,
  };

  static const images = {
    'small': 20.0,
    'medium': 40.0,
    'large': 60.0,
    'logo': 200.0
  };

  static bool isTablet(BuildContext context) {
    return ScreenUtil().deviceType(context) == DeviceType.tablet;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }

  static double getResponsiveSize(BuildContext context, double baseSize,
      {bool? isOpposite}) {
    double screenSize = 0.0;
    if (isOpposite != null) {
      if (isOpposite == true) {
        screenSize = isPortrait(context)
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width;
      } else {
        screenSize = isPortrait(context)
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
      }
    } else {
      screenSize = isPortrait(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height;
    }

    return screenSize * baseSize;
  }

  static double getFontSize(BuildContext context, double baseFontSize) {
    double screenSize = isPortrait(context)
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
    double baseScreenWidth = 375.0; // Standard screen width
    double scaleFactor = screenSize / baseScreenWidth;
    return baseFontSize * scaleFactor;
  }
}
