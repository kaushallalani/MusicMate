import 'package:flutter/material.dart';
import 'package:musicmate/constants/theme.dart';

class Styles {
  Styles._();

  static const TextStyle hintStyle =
      TextStyle(color: Colors.grey, fontFamily: Fonts.roboto);
  static const TextStyle errorStyle =
      TextStyle(fontFamily: Fonts.roboto, color: Colors.red);
  static OutlineInputBorder borderStyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade400),
    borderRadius: BorderRadius.circular(5),
  );

  static OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: AppColor.aquaBlue),
      borderRadius: BorderRadius.circular(5));
}
