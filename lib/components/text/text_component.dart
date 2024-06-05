import 'package:flutter/material.dart';
import 'styles.dart';

class TextComponent extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final int? maxlines;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  const TextComponent(
      {super.key,
      required this.text,
      this.textStyle = Styles.textstyle,
      this.maxlines,
      this.textAlign,
      this.textScaler});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign ?? TextAlign.left,
        maxLines: maxlines,
        textScaler: textScaler,
        style: Styles.textstyle.copyWith(
            fontSize: textStyle?.fontSize,
            fontFamily: textStyle?.fontFamily,
            color: textStyle?.color,
            fontWeight: textStyle?.fontWeight));
  }
}
