import 'package:flutter/material.dart';
import 'package:musicmate/constants/index.dart';

import 'styles.dart';

class TextComponent extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final int? maxlines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const TextComponent({
    super.key,
    required this.text,
    this.textStyle,
    this.maxlines,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Metrics.isTablet(context);
    final isPortrait = Metrics.isPortrait(context);
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxlines,
      overflow: overflow,
      textScaler: isTablet == true
          ? isPortrait
              ? const TextScaler.linear(0.6)
              : const TextScaler.linear(0.4)
          : const TextScaler.linear(1),
      style: textStyle?.copyWith(
            color: textStyle?.color ?? Styles.textstyle(context).color,
            fontSize: textStyle?.fontSize ?? Styles.textstyle(context).fontSize,
            fontFamily:
                textStyle?.fontFamily ?? Styles.textstyle(context).fontFamily,
            fontWeight:
                textStyle?.fontWeight ?? Styles.textstyle(context).fontWeight,
            backgroundColor: textStyle?.backgroundColor ??
                Styles.textstyle(context).backgroundColor,
            wordSpacing:
                textStyle?.wordSpacing ?? Styles.textstyle(context).wordSpacing,
            letterSpacing: textStyle?.letterSpacing ??
                Styles.textstyle(context).letterSpacing,
            overflow: textStyle?.overflow ?? Styles.textstyle(context).overflow,
          ) ??
          Styles.textstyle(context),
    );
  }
}
