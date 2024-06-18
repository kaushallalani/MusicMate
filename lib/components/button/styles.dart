import 'package:musicmate/constants/theme.dart';
import 'package:flutter/material.dart';

class Styles {
  Styles._();

  static const btnStyle = BoxDecoration(
    color: AppColor.grey,
    borderRadius: BorderRadius.zero,
  );

  static final btnstyle = ElevatedButton.styleFrom(
      backgroundColor: AppColor.grey,
      padding: const EdgeInsets.all(5),
      shape: const RoundedRectangleBorder(side: BorderSide.none));
}
