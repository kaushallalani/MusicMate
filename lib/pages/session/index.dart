import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/bloc/session/session_bloc.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';

class Session extends StatefulWidget {
  const Session({super.key});

  @override
  State<Session> createState() => _SessionState();
}

class _SessionState extends State<Session> {
  late SessionModel? currentSession;
  late List<UserModel?> sessionUsers;

  @override
  void initState() {
    super.initState();
    currentSession = SessionModel();
    sessionUsers = [];
    BlocProvider.of<SessionBloc>(context).add(FetchCurrentSession());
    Timer(const Duration(seconds: 1), () => fetchAllUserDetails());
  }

  void fetchAllUserDetails() {
    BlocProvider.of<SessionBloc>(context)
        .add(FetchSessionUserDetails(currentSession!.allUsers!));
  }

  @override
  void didChangeDependencies() {
    print('call');
    super.didChangeDependencies();
    if (currentSession!.id != null) {
      fetchAllUserDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionSuccessState) {
          setState(() {
            currentSession = state.sessionData!;
          });

          print('sesssion => ${state.sessionUsers.length}');
          if (state.sessionUsers.isNotEmpty) {
            setState(() {
              sessionUsers = state.sessionUsers;
            });
          }
          Logger().d(state.sessionUsers.length);
        }
        if (state is SessionErrorState) {
          Logger().d(state.errorMessage);
        }
      },
      builder: (context, state) {
        print('insessions');
        print(state);
        return Scaffold(
          backgroundColor: AppColor.white,
          appBar: AppBar(
            leadingWidth: 40,
            titleSpacing: 0,
            bottom: PreferredSize(
              preferredSize: Size.zero,
              child: Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColor.headerBorder))),
              ),
            ),
            leading: IconButton(
              icon: const Icon(
                Entypo.left_open_big,
                size: 20,
              ),
              onPressed: () {
                print('pressed');
                context.pop();
              },
            ),
            actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(Metrics.width(context) * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent(
                      text: currentSession!.sessionName != null
                          ? currentSession!.sessionName!
                          : '',
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: FontSize.xmedium),
                    ),
                    TextComponent(
                      text: sessionUsers.isNotEmpty
                          ? 'By ${sessionUsers[0]!.fullName.toString()}'
                          : '',
                      textStyle: const TextStyle(
                          color: AppColor.grey, fontSize: FontSize.small),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]),
                                child: sessionUsers.isNotEmpty
                                    ? TextComponent(
                                        text: sessionUsers[0]!.fullName![0],
                                        textStyle: const TextStyle(
                                            color: AppColor.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: FontSize.small),
                                      )
                                    : null),
                            TextComponent(
                              text: ' : ${sessionUsers.length} users',
                              textStyle: const TextStyle(
                                  color: AppColor.grey,
                                  fontSize: FontSize.small),
                            )
                          ],
                        ),
                        InkWell(
                          child: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.aquaBlue.withOpacity(0.7)),
                            child: const Icon(FontAwesome.play),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
