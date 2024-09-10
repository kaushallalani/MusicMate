import 'package:flutter/material.dart';
import 'package:musicmate/constants/index.dart';
import 'package:musicmate/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NewBox extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? boxPadding;
  final EdgeInsetsGeometry? boxMargin;

  const NewBox({
    super.key,
    required this.child,
    this.boxPadding,
    this.boxMargin,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).darkTheme;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            //Darker
            BoxShadow(
              color: isDarkMode ? Colors.black : Colors.grey.shade500,
              blurRadius: 15,
              offset: const Offset(4, 4),
            ),
            BoxShadow(
              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
              blurRadius: 15,
              offset: const Offset(-4, -4),
            ),
          ]),
      padding: boxPadding ?? EdgeInsets.all(Metrics.width(context) * 0.04),
      margin: boxMargin,
      child: child,
    );
  }
}
