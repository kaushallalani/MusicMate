import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';
import 'package:musicmate/constants/index.dart';
import 'package:musicmate/models/hiveUser.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:musicmate/pages/restart/index.dart';
import 'package:musicmate/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicmate/constants/i18n/strings.g.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserModel? _userDetails;

  AppLocale? selectedLanguage;
  var userBox = Hive.box('userBox');

  @override
  void initState() {
    super.initState();
    // context.read<DashboardBloc>().add(GetUserDetails());
    _userDetails = UserModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedLanguage = LocaleSettings.currentLocale;
  }

  void handleLangugeChange(context) {
    Logger().d('LL => $selectedLanguage');
    Logger().d(selectedLanguage == AppLocale.en);
    switch (selectedLanguage!) {
      case AppLocale.en:
        LocaleSettings.setLocale(AppLocale.en);
        break;
      case AppLocale.ar:
        LocaleSettings.setLocale(AppLocale.ar);
        break;
      case AppLocale.hi:
        LocaleSettings.setLocale(AppLocale.hi);
        break;
    }
    Logger().d('userrr => $selectedLanguage');
    userBox.put('appLanguage', selectedLanguage!.languageCode);
    Restart.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardInitial) {
          Logger().d('init');
        }
        if (state is DashboardLoadingState) {
          Logger().d('loadinggg');
        }
        if (state is DashboardSuccessState) {
          Logger().d('success');
          // setState(() {
          //   userDetails = state.currentUser!;
          // });
        }

        if (state is DashboardFailureState) {
          Logger().d('fail');
        }
      },
      builder: (context, state) {
        print('settings');

        Logger().d(state);
        Logger().d('LL => $selectedLanguage');

        if (state is DashboardLoadingState) {}
        return Scaffold(
          appBar: AppBar(
            title: const Text('S E T T I N G S'),
          ),
          body: Padding(
            padding: EdgeInsets.all(Metrics.width(context) * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //dark mode
                      const Text(
                        "Dark Mode",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      //switch
                      Consumer(builder: (BuildContext context,
                          ThemeProvider provider, Widget? child) {
                        return CupertinoSwitch(
                          value: provider.darkTheme,
                          onChanged: (val) => provider.toggleTheme(),
                        );
                      }),
                    ],
                  ),
                ),
                TextComponent(
                  text: t.appLanguage,
                  textStyle: const TextStyle(color: AppColor.white),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = AppLocale.en;
                    });
                    handleLangugeChange(context);
                    // LocaleSettings.setLocale(AppLocale.en);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextComponent(
                          text: t.english,
                          textStyle: const TextStyle(color: AppColor.white),
                        ),
                        selectedLanguage == AppLocale.en
                            ? const Icon(
                                Icons.check,
                                color: AppColor.aquaBlue,
                                size: 20,
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = AppLocale.ar;
                    });
                    // LocaleSettings.setLocale(AppLocale.ar);
                    handleLangugeChange(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextComponent(
                          text: t.arabic,
                          textStyle: const TextStyle(color: AppColor.white),
                        ),
                        selectedLanguage == AppLocale.ar
                            ? const Icon(
                                Icons.check,
                                color: AppColor.aquaBlue,
                                size: 20,
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedLanguage = AppLocale.hi;
                    });
                    // LocaleSettings.setLocale(AppLocale.ar);
                    handleLangugeChange(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColor.white),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextComponent(
                          text: t.hindi,
                          textStyle: const TextStyle(color: AppColor.white),
                        ),
                        selectedLanguage == AppLocale.hi
                            ? const Icon(
                                Icons.check,
                                color: AppColor.aquaBlue,
                                size: 20,
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
