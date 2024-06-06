// import 'package:demo/themes/theme_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'pages/home/index.dart';
// import 'package:demo/models/playlistProvider.dart';

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ThemeProvider()),
//         ChangeNotifierProvider(create: (context) => Playlistprovider())
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//       theme: Provider.of<ThemeProvider>(context).themeData,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:musicmate/models/playlistProvider.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/navigation/navigation.dart';
import 'package:musicmate/themes/dark_mode.dart';
import 'package:musicmate/themes/light_mode.dart';
import 'package:musicmate/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Playlistprovider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final routeConfig = NavigationConfig(stackNavigation);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Provider Theme Changer',
          theme: value.darkTheme == false ? lightMode : darkMode,
          supportedLocales: {const Locale('en', '')},
          restorationScopeId: 'app',
          routerConfig: routeConfig.router,
        ),
      ),
    );
  }
}
