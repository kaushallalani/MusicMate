import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/bloc/playback/playback_bloc.dart';
import 'package:musicmate/bloc/session/session_bloc.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';
import 'package:musicmate/firebase_options.dart';
import 'package:musicmate/models/hiveUser.dart';
import 'package:musicmate/pages/restart/index.dart';
import 'package:musicmate/services/playlistProvider.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/navigation/navigation.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:musicmate/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicmate/injectionContainer/injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:musicmate/bloc/authentication/authentication_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  Logger().d('main called');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PlaylistProvider())
      ],
      child: TranslationProvider(
        child: Restart(child: MyApp()),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  String? appLanguage;
  final routeConfig = NavigationConfig(stackNavigation);
  var userBox = Hive.box('userBox');
  List<AppLocale>? appLocales = AppLocale.values;

  @override
  void initState() {
    super.initState();
    appLanguage = userBox.get('appLanguage');
    WidgetsBinding.instance
        .addPostFrameCallback((_) async {handleGetLanguage();});
  }

  handleGetLanguage() async {
    AppLocale? matchingLocale = appLocales!.firstWhere(
        (locale) => locale.languageCode == appLanguage,
        orElse: () => AppLocale.en);
    LocaleSettings.setLocale(matchingLocale);
    Logger().d('currentLang=> ${LocaleSettings.useDeviceLocale()}');
  }

  void initialCall() async {
    var prefs = await SharedPreferences.getInstance();
    var islogin = prefs.getBool('isLogin');

    if (islogin != null) {
      if (islogin == true) {
        setState(() {
          isLogin = true;
        });
      } else {
        setState(() {
          isLogin = false;
        });
      }
    } else {
      setState(() {
        isLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger().d('lang => $appLanguage');
    Logger().d('lang1 => ${LocaleSettings.currentLocale}');
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) => MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
                create: (BuildContext context) =>
                    di.serviceLocater<AuthenticationBloc>()),
            BlocProvider<DashboardBloc>(
                create: (BuildContext context) =>
                    di.serviceLocater<DashboardBloc>()),
            BlocProvider<SessionBloc>(
                create: (BuildContext context) =>
                    di.serviceLocater<SessionBloc>()),
            BlocProvider<PlaybackBloc>(
                create: (BuildContext content) =>
                    di.serviceLocater<PlaybackBloc>())
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'MusicMate',
            theme: ThemeData(brightness: Brightness.light),
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: ThemeMode.system,
            supportedLocales: {const Locale('en', '')},
            restorationScopeId: 'app',
            routerConfig: routeConfig.router,
          ),
        ),
      ),
    );
  }
}
