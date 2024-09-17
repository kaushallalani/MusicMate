import 'package:flutter/material.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/index.dart';

import 'styles.dart';

class ButtonComponent extends StatelessWidget {
  final VoidCallback? onPressed;
  final String btnTitle;
  final TextStyle? btnTextStyle;
  final Widget? leadingChild;
  final EdgeInsetsGeometry? btnMargin;
  final EdgeInsetsGeometry? btnPadding;
  final BoxDecoration? btnStyle;
  final SizedBox? btnSize;

  const ButtonComponent({
    super.key,
    this.onPressed,
    required this.btnTitle,
    this.btnTextStyle,
    this.leadingChild,
    this.btnMargin,
    this.btnStyle,
    this.btnSize,
    this.btnPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Metrics.isTablet(context);

    return Container(
      margin: btnMargin,
      width: btnSize?.width,
      height: btnSize?.height ?? Metrics.height(context) * 0.04,
      decoration: Styles.btnStyle(context).copyWith(
          gradient: btnStyle?.gradient,
          color: btnStyle?.color,
          shape: btnStyle?.shape,
          border: btnStyle?.border,
          borderRadius: btnStyle?.borderRadius,
          boxShadow: btnStyle?.boxShadow),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (leadingChild != null) leadingChild!,
            Padding(
              padding: btnPadding ?? const EdgeInsets.all(0),
              child: TextComponent(
                text: btnTitle,
                textStyle: btnTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
