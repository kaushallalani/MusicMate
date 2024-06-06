import 'package:flutter/material.dart';
import 'package:musicmate/components/bottomNav/custom_bottom_navigation.dart';
import 'package:musicmate/components/bottomNav/custom_bottom_navigation_bar_item.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/pages/home/index.dart';
import 'package:musicmate/pages/library/index.dart';
import 'package:musicmate/pages/search/index.dart';
import 'package:musicmate/pages/settings/index.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pageIndex = 0;

  List<Widget> pages = [
    const HomePage(),
    const Search(),
    const SettingsPage(),
    const Library()
  ];

  List<Map<String, dynamic>> pageItems = [
    {
      'icon': const Icon(FontAwesome5.home),
      'label': Text(t.home),
    },
    {
      'icon': const Icon(FontAwesome5.search),
      'label': Text(t.search),
    },
    {
      'icon': const Icon(Icons.settings),
      'label': Text(t.settings),
    },
    {
      'icon': const ImageIcon(const AssetImage(Images.library)),
      'label': Text(t.library),
    }
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(
        pageItems: pageItems,
        onTap: _onItemTapped,
        pageIndex: pageIndex,
        bottomBarStyle: const BoxDecoration(
            color: AppColor.white,
            border: Border(
                top: BorderSide(width: 1, color: AppColor.headerBorder))),
      ),
      body: pages[pageIndex],
    );
  }
}
