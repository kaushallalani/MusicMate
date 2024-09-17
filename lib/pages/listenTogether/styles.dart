import 'package:flutter/material.dart';
import 'package:musicmate/constants/index.dart';

class Styles {
  Styles._();

  static TextStyle btnTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).customColors.blackColor,
        fontSize: FontSize.normal);
  }

  static BoxDecoration sessionBtn(BuildContext context) => BoxDecoration(
      color: Theme.of(context).customColors.customColor2,
      borderRadius: BorderRadius.circular(10));
}
