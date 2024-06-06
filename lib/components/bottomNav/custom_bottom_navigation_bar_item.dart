import 'package:flutter/material.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final Widget? label;
  final Color? backgroundColor;
  final String? tooltip;

  const CustomBottomNavigationBarItem(
      {super.key,
      required this.onTap,
      required this.icon,
      this.label,
      this.backgroundColor,
      this.tooltip});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, if (label != null) label!],
      ),
    );
  }
}
