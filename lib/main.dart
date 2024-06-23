import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:musicmate/bloc/session/session_bloc.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';
import 'package:musicmate/firebase_options.dart';
import 'package:musicmate/models/playlistProvider.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/navigation/navigation.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:musicmate/services/audio_handlers.dart';
import 'package:musicmate/themes/dark_mode.dart';
import 'package:musicmate/themes/light_mode.dart';
import 'package:musicmate/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicmate/injectionContainer/injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:musicmate/services/audio_handlers.dart';
import 'package:musicmate/bloc/authentication/authentication_bloc.dart';

final getIt = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await initAudioService();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Playlistprovider())
      ],
      child: TranslationProvider(child: const MyApp()),
    ),
  );
}

Future<void> initAudioService() async {
  getIt.registerSingleton<AudioHandler>(await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.musicmate.channel.audio',
      androidNotificationChannelName: 'Music playback',
      androidNotificationOngoing: true,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;
  final routeConfig = NavigationConfig(stackNavigation);

  @override
  void initState() {
    super.initState();
    // initialCall();
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
                    di.serviceLocater<SessionBloc>())
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'MusicMate',
            theme: value.darkTheme == false ? lightMode : darkMode,
            supportedLocales: {const Locale('en', '')},
            restorationScopeId: 'app',
            routerConfig: routeConfig.router,
          ),
        ),
      ),
    );
  }
}
