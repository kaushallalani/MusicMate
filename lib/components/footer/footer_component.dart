import 'package:flutter/material.dart';
import 'package:musicmate/constants/theme.dart';
import 'styles.dart';

class FooterComponent extends StatelessWidget {
  final SizedBox? footerSize;
  final Widget child;
  final BoxDecoration? footerStyle;
  final EdgeInsetsGeometry? footerMargin;
  final EdgeInsetsGeometry? footerPadding;
  final int? flex;

  const FooterComponent(
      {super.key,
      this.footerSize,
      required this.child,
      this.footerStyle,
      this.footerMargin,
      this.footerPadding, this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          child: Container(
              height: footerSize?.height ?? Metrics.height(context) * 0.09,
              margin: footerMargin,
              width: double.infinity,
              padding: footerPadding,
              decoration: Styles.footerStyle.copyWith(
                color: footerStyle?.color,
                gradient: footerStyle?.gradient,
                shape: footerStyle?.shape,
                border: footerStyle?.border,
                borderRadius: footerStyle?.borderRadius,
              ),
              child: child),
        ),
      ),
    );
  }
}
