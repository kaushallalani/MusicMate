import 'package:flutter/material.dart';

class FooterComponent extends StatelessWidget {
  final Widget child;
  final BoxDecoration? footerStyle;
  final EdgeInsetsGeometry? footerMargin;
  final EdgeInsetsGeometry? footerPadding;

  const FooterComponent({
    super.key,
    required this.child,
    this.footerStyle,
    this.footerMargin,
    this.footerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        margin: footerMargin,
        padding: footerPadding,
        decoration: footerStyle ?? BoxDecoration(color: Colors.grey),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [child],
        ),
      ),
    );
  }
}
