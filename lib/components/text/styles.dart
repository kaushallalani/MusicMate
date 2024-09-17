import 'package:flutter/material.dart';
import 'package:musicmate/constants/index.dart';

class Styles {
  Styles._();
  static textstyle(BuildContext context) {
    final isTablet = Metrics.isTablet(context);
    final isPortrait = Metrics.isPortrait(context);
    return TextStyle(
        color: Theme.of(context).customColors.blackColor,
        fontSize: isTablet && !isPortrait
            ? Metrics.getFontSize(context, 30)
            : Metrics.getFontSize(context, FontSize.medium),
        fontFamily: Fonts.roboto);
  }
}
