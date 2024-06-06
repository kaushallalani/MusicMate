import 'dart:io';
import 'package:flutter/material.dart';

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
  static const double extraSmallMargin = 3.0;
  static const double smallMargin = 5.0;
  static const double doubleSection = 50.0;
  static const double horizontalLineHeight = 1.0;
  static const double semiBaseMargin = 15.0;

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
}
