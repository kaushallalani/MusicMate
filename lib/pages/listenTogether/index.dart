import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/session.dart';
import 'package:musicmate/models/user.dart';
import 'package:musicmate/navigation/app_navigation.dart';
import 'package:musicmate/bloc/dashboard/dashboard_bloc.dart';
import 'styles.dart';

class ListenTogether extends StatefulWidget {
  const ListenTogether({super.key});

  @override
  State<ListenTogether> createState() => _ListenTogetherState();
}

class _ListenTogetherState extends State<ListenTogether> {
  final TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> errors;
  late UserModel? userDetails;
  late List<SessionModel?> userSessions;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    errors = {};
    userDetails = UserModel();
    userSessions = [];
    isLoading = true;
    fetchUserSessions();
  }

  bool handleValidation() {
    Map<String, dynamic> error = {};
    bool isValid = true;
    final sessionName = nameController.text;
    if (sessionName.isEmpty) {
      error['name'] = 'Session Name cannot be empty';
      isValid = false;
    }

    setState(() {
      errors = error;
    });

    return isValid;
  }

  void handleOnCreateSession() {
    final isValidated = _formKey.currentState!.validate();
    Logger().d(isValidated);
    if (isValidated == true) {
      final sessionData = SessionModel(
          sessionName: nameController.text,
          currentSongId: '',
          allUsers: [userDetails!.id!],
          ownerId: userDetails!.id,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString());

      BlocProvider.of<DashboardBloc>(context)
          .add(CreateSession(sessionModel: sessionData));

      context.pop();

      // context.push(NAVIGATION.session);
    }
  }

  void fetchUserSessions() {
    BlocProvider.of<DashboardBloc>(context).add(GetUserDetails());
    Timer(const Duration(seconds: 2), () {
      BlocProvider.of<DashboardBloc>(context)
          .add(FetchUserSessions(id: userDetails!.id!));
    });
  }

  @override
  Widget build(BuildContext context) {
    Logger().d(errors);
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardInitial) {
          // Logger().d(state.currentUser!.id);
        }
        if (state is DashboardLoadingState) {
          // Logger().d(state.currentUser!.id);
        }
        if (state is DashboardInitial) {
          Logger().d('init listen');
        }
        if (state is DashboardSuccessState) {
          setState(() {
            userDetails = state.currentUser!;
          });
        }
        if (state is SessionSuccessState) {
          setState(() {
            userSessions = state.userSessions;
            isLoading = false;
          });

          if (state.sessionId != null) {
            context.pushNamed(
              NAVIGATION.session,
            );
          }
        }
      },
      builder: (context, state) {
        Logger().d(userDetails!.email);
        if (state is DashboardInitial) {
          Logger().d(state.sessionData);
        }
        if (state is DashboardLoadingState) {
          Logger().d(state.currentUser);
        }

        return Scaffold(
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
                  horizontal: Metrics.width(context) * 0),
              icon: const Icon(
                Entypo.left_open_big,
                size: 20,
              ),
              onPressed: () {
                context.pop();
              },
            ),
            title: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Metrics.width(context) * 0),
              child: const TextComponent(text: 'Sessions'),
            ),
          ),
          body: isLoading == true
              ? Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.aquaBlue,
                    ),
                  ),
                )
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: Metrics.width(context) * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 0,
                        child: const TextComponent(
                          text: 'Your Sessions',
                          textStyle: TextStyle(
                              fontSize: FontSize.medium,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      userSessions.length != 0
                          ? Expanded(
                              flex: 1,
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    SessionModel? sessionItem =
                                        userSessions[index];
                                    return Material(
                                      elevation: 2,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            gradient: LinearGradient(
                                                colors: AppColor.blueGradient)),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          title: TextComponent(
                                            text: sessionItem!.sessionName!,
                                            textStyle: const TextStyle(
                                                color: AppColor.white,
                                                fontSize: FontSize.xmedium,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              const Icon(
                                                FontAwesome5.users,
                                                size: 15,
                                                color: AppColor.white,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: TextComponent(
                                                  text: sessionItem
                                                      .allUsers!.length
                                                      .toString(),
                                                  textStyle: const TextStyle(
                                                      color: AppColor.white,
                                                      fontSize: FontSize.small),
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: InkWell(
                                              onTap: () {
                                                print('pressed');
                                                BlocProvider.of<DashboardBloc>(
                                                        context)
                                                    .add(SetCurrentSession(
                                                        sessionModel:
                                                            sessionItem));
                                                context.pushNamed(
                                                  NAVIGATION.session,
                                                );
                                              },
                                              child: const TextComponent(
                                                text: 'Join',
                                                textStyle: TextStyle(
                                                    color: AppColor.white,
                                                    fontSize: FontSize.normal),
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: userSessions.length))
                          : Expanded(
                              child: Container(
                                // color: Colors.red,
                                // height: double.infinity,
                                child: Center(
                                  child: TextComponent(
                                    text: 'No Sessions Found',
                                  ),
                                ),
                              ),
                            ),
                      FooterComponent(
                        flex: 0,
                        footerMargin: EdgeInsets.symmetric(
                            vertical: Metrics.width(context) * 0.04),
                        // footerPadding: const EdgeInsets.all(5),
                        footerSize: SizedBox(
                          height: Metrics.height(context) * 0.05,
                        ),
                        footerStyle: const BoxDecoration(
                            // color: Colors.orange,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ButtonComponent(
                                  btnTitle: 'Create Session',
                                  btnPadding: const EdgeInsets.all(5),
                                  btnStyle: Styles.sessionBtn,
                                  btnSize: SizedBox(
                                    width: Metrics.width(context) * 0.4,
                                  ),
                                  onPressed: () {
                                    Logger().d(' create pressed');
                                  },
                                  btnTextStyle: Styles.btnTextStyle),
                            ),
                            ButtonComponent(
                                btnTitle: 'Join Session',
                                btnPadding: const EdgeInsets.all(5),
                                btnStyle: Styles.sessionBtn,
                                btnSize: SizedBox(
                                  width: Metrics.width(context) * 0.4,
                                ),
                                onPressed: () {
                                  Logger().d('join pressed');
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) {
                                        return Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                              top:
                                                  Metrics.width(context) * 0.04,
                                              left:
                                                  Metrics.width(context) * 0.04,
                                              right: Metrics.width(context) *
                                                  0.04),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const TextComponent(
                                                  text: 'Add Session Details',
                                                  textStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          FontSize.xmedium),
                                                ),
                                                TextFormFieldComponent(
                                                  controller: nameController,
                                                  hintText:
                                                      'Enter Session Name',
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Session name cannot be empty';
                                                    }
                                                    // Return null if the input is valid
                                                    return null;
                                                  },
                                                  focusedBorder:
                                                      const UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: AppColor
                                                                  .aquaBlue)),
                                                ),
                                                Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: Metrics.width(
                                                                context) *
                                                            0.04),
                                                    child: ButtonComponent(
                                                      btnTitle: 'Create',
                                                      btnPadding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      btnStyle:
                                                          Styles.sessionBtn,
                                                      btnTextStyle:
                                                          Styles.btnTextStyle,
                                                      onPressed: () {
                                                        handleOnCreateSession();
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                btnTextStyle: Styles.btnTextStyle)
                          ],
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
