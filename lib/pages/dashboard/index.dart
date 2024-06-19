import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:musicmate/bloc/authentication/authentication_bloc.dart';
import 'package:musicmate/pages/home/index.dart';
import 'package:musicmate/pages/library/index.dart';
import 'package:musicmate/pages/search/index.dart';
import 'package:musicmate/pages/settings/index.dart';
import 'package:unique_identifier/unique_identifier.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  int pageIndex = 0;
  String? deviceId;
  AppLifecycleState? appLifecycleState;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _userStream =
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots();

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
      'icon': const ImageIcon(AssetImage(Images.library)),
      'label': Text(t.library),
    }
  ];

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceId();
    Logger().d('dashboard called');
    WidgetsBinding.instance.addObserver(this);
    BlocProvider.of<DashboardBloc>(context).add(GenerateAccessToken());
    BlocProvider.of<DashboardBloc>(context).add(FetchUserDataFromFirebase());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    setState(() {
      appLifecycleState = state;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void getDeviceId() async {
    String? id = await UniqueIdentifier.serial;
    setState(() {
      deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Logger().d('appstate => ${appLifecycleState}');
    return StreamBuilder<Object>(
        stream: _userStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            if (data['deviceUniqueId'] != deviceId) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                BlocProvider.of<AuthenticationBloc>(context).add(SignoutUser());
                context.go(NAVIGATION.login);
              });
            } else {
              return Scaffold(
                bottomNavigationBar: CustomBottomNavigation(
                  pageItems: pageItems,
                  onTap: _onItemTapped,
                  pageIndex: pageIndex,
                  bottomBarStyle: const BoxDecoration(
                      color: AppColor.white,
                      border: Border(
                          top: BorderSide(
                              width: 1, color: AppColor.headerBorder))),
                ),
                body: pages[pageIndex],
              );
            }
          }
          return const Center(child: Text('Something went wrong'));
        });
  }
}
