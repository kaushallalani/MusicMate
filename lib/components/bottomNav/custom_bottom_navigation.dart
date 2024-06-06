import 'package:flutter/material.dart';
import 'package:musicmate/components/bottomNav/custom_bottom_navigation_bar_item.dart';
import 'package:musicmate/constants/theme.dart';

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
    return Container(
        height: Metrics.height(context) * 0.08,
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
                          : AppColor.black,
                      size: 24,
                    ),
                    child: item['icon']),
                label: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: FontSize.medium,
                    color:
                        pageIndex == index ? AppColor.aquaBlue : AppColor.black,
                  ),
                  child: item['label'] as Text,
                ),
                backgroundColor: item['backgroundColor'] as Color?,
              ));
            }).toList()));
  }
}
