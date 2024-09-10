import 'package:flutter/material.dart';
import 'package:musicmate/components/bottomNav/custom_bottom_navigation_bar_item.dart';
import 'package:musicmate/constants/index.dart';

class CustomBottomNavigation extends StatelessWidget {
  final List<Map<String?, dynamic>> pageItems;
  final BoxDecoration? bottomBarStyle;
  final int pageIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigation({
    super.key,
    required this.pageItems,
    this.bottomBarStyle,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;
    return Container(
        height: Metrics.getResponsiveSize(context, 0.08, isOpposite: true),
        decoration: bottomBarStyle,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: pageItems.asMap().entries.map((entry) {
              int index = entry.key;
              final item = entry.value;
              return Expanded(
                  child: CustomBottomNavigationBarItem(
                onTap: () {
                  onTap(index);
                  item['onTap'];
                },
                icon: IconTheme(
                    data: IconThemeData(
                      color: pageIndex == index
                          ? AppColor.aquaBlue
                          : colors.blackColor,
                      size: 22,
                    ),
                    child: item['icon']),
                label: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: Metrics.getFontSize(context, FontSize.normal),
                      color: pageIndex == index
                          ? AppColor.aquaBlue
                          : colors.blackColor,
                    ),
                    child: item['label'] as Text,
                  ),
                ),
                backgroundColor: item['backgroundColor'] as Color?,
              ));
            }).toList()));
  }
}
