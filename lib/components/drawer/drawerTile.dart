
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/index.dart';

class DrawerTile extends StatelessWidget {
  final int index;
  final int? selectedIndex;
  final String text;
  final Function onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;

  const DrawerTile({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.text,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    final bool isTablet = Metrics.isTablet(context);
    final bool isPortrait = Metrics.isPortrait(context);

    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(Metrics.doubleButtonRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Metrics.semiBaseMargin, horizontal: Metrics.buttonRadius),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(Metrics.doubleButtonRadius),
        ),
        child: Row(
          children: [
            Icon(
              FontAwesome.angle_right,
              color: isSelected ? selectedTextColor : unselectedTextColor,
              size: isTablet
                  ? Metrics.getResponsiveSize(context, 0.04)
                  : Metrics.getResponsiveSize(context, 0.08),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Metrics.smallMargin),
              child: TextComponent(
                text: text,
                textStyle: TextStyle(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontSize: isTablet
                      ? isPortrait
                          ? Metrics.getFontSize(context, FontSize.normal)
                          : Metrics.getFontSize(context, 25)
                      : Metrics.getFontSize(context, FontSize.normal),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
