import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/bloc/session/session_bloc.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/session.dart';

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  late SessionModel? currentSession;

  @override
  void initState() {
    super.initState();
    currentSession = SessionModel();
    BlocProvider.of<SessionBloc>(context).add(FetchCurrentSession());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionSuccessState) {
          Logger().d(state.sessionData!.sessionName);
          setState(() {
            currentSession = state.sessionData!;
          });
        }
        if (state is SessionErrorState) {
          Logger().d(state.errorMessage);
        }
      },
      builder: (context, state) {
        Logger().d(state);
        print('insessions');
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
              leadingWidth: 0,
              bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColor.headerBorder))),
                ),
              ),
              leading: IconButton(
                padding: EdgeInsets.symmetric(
                    horizontal: Metrics.width(context) * 0.04),
                icon: const Icon(
                  Entypo.left_open_big,
                  size: 20,
                ),
                onPressed: () {
                  print('pressed');
                  context.pop();
                },
              ),
              title: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Metrics.width(context) * 0.06),
                child: TextComponent(
                    text: currentSession!.sessionName != null
                        ? currentSession!.sessionName!
                        : ''),
              )),
        );
      },
    );
  }
}
