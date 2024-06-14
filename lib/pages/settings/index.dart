import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'package:musicmate/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserModel? _userDetails;

  @override
  void initState() {
    super.initState();
    // context.read<DashboardBloc>().add(GetUserDetails());
    _userDetails = UserModel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      // bloc: settingsBloc,
      listener: (context, state) {
        if (state is DashboardInitial) {
          Logger().d('init');
        }
        if (state is DashboardLoadingState) {
          Logger().d('loadinggg');
          // Logger().d(state.currentUser!.email);
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
        if (state is DashboardLoadingState) {}
        return Scaffold(
          appBar: AppBar(
            title: const Text('S E T T I N G S'),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //dark mode
                const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                //switch
                Consumer(builder: (BuildContext context, ThemeProvider provider,
                    Widget? child) {
                  return CupertinoSwitch(
                    value: provider.darkTheme,
                    onChanged: (val) => provider.toggleTheme(),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
