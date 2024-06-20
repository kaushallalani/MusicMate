import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:flutter/material.dart';
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

    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: btnMargin,
        width: btnSize?.width,
        height: btnSize?.height ?? Metrics.height(context) * 0.05,
        decoration: Styles.btnStyle.copyWith(
            gradient: btnStyle?.gradient,
            color: btnStyle?.color,
            shape: btnStyle?.shape,
            border: btnStyle?.border,
            borderRadius: btnStyle?.borderRadius,
            boxShadow: btnStyle?.boxShadow),
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

        // ElevatedButton(
        //   onPressed: onPressed,
        //   style: Styles.btnStyle.copyWith(
        //       shape: btnStyle?.shape,
        //       backgroundColor: btnStyle?.backgroundColor,
        //       padding: btnStyle?.padding,
        //       animationDuration: btnStyle?.animationDuration,
        //       minimumSize: btnStyle?.minimumSize,
        //       maximumSize: btnStyle?.maximumSize,
        //       textStyle: btnStyle?.textStyle),
        //   child:
        // Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       if (leadingChild != null) leadingChild!,
        //       Padding(
        //         padding: btnPadding ?? const EdgeInsets.all(0),
        //         child: TextComponent(
        //           text: btnTitle,
        //           textStyle: btnTextStyle,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
