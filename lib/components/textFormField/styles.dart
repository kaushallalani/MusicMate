import 'package:flutter/material.dart';
import 'package:musicmate/constants/index.dart';

class Styles {
  Styles._();

  static TextStyle hintStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).customColors.placeholder,
      fontFamily: Fonts.roboto,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle errorStyle(BuildContext context) {
    return TextStyle(
        fontFamily: Fonts.roboto,
        color: Theme.of(context).customColors.redColor,
        fontSize: Metrics.getFontSize(
            context,
            (Metrics.isTablet(context) && !Metrics.isPortrait(context))
                ? FontSize.small * 2
                : FontSize.small));
  }

  static OutlineInputBorder borderStyle(BuildContext context) =>
      OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).customColors.borderColor, width: 0.1),
        borderRadius: BorderRadius.circular(Metrics.doubleButtonRadius),
      );

  static OutlineInputBorder focusedBorder(BuildContext context) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).customColors.bg, width: 0.1),
        borderRadius: BorderRadius.circular(Metrics.doubleButtonRadius));
  }

  static TextStyle titleText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).customColors.dimGrey,
        fontFamily: Fonts.roboto,
        fontWeight: FontWeight.w400,
        fontSize: Metrics.getFontSize(
            context,
            (Metrics.isTablet(context) && !Metrics.isPortrait(context))
                ? 25
                : FontSize.normal));
  }

  static TextStyle subText(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).customColors.redColor, fontFamily: Fonts.roboto);
  }

  static OutlineInputBorder errorBorder(BuildContext context) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(Metrics.doubleBorderRadius),
        borderSide:
            BorderSide(color: Theme.of(context).customColors.redColor, width: 0.8));
  }

  static TextStyle inputTextStyle(BuildContext context) => TextStyle(
      fontFamily: Fonts.roboto, color: Theme.of(context).customColors.blackColor);
}
