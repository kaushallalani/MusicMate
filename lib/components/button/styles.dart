import 'package:musicmate/constants/index.dart';
import 'package:flutter/material.dart';

class Styles {
  Styles._();

  static btnStyle(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).customColors.customColor1,
      borderRadius: BorderRadius.circular(Metrics.doubleBorderRadius),
    );
  }

  static btnstyle(BuildContext context) {
    return ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).customColors.blackColor,
        padding: const EdgeInsets.all(Metrics.borderRadius),
        shape: const RoundedRectangleBorder(side: BorderSide.none));
  }
}
