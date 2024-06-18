import 'dart:async';
import 'dart:math';

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
import 'package:fluttertoast/fluttertoast.dart';
import 'styles.dart';

class ListenTogether extends StatefulWidget {
  const ListenTogether({super.key});

  @override
  State<ListenTogether> createState() => _ListenTogetherState();
}

class _ListenTogetherState extends State<ListenTogether> {
  final TextEditingController nameController =
      TextEditingController(text: "mwf-6gy-6i7");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
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
      final code = generateSessionCode();
      final sessionData = SessionModel(
          sessionName: nameController.text,
          currentSongId: '',
          allUsers: [userDetails!.id!],
          sessionCode: code,
          ownerId: userDetails!.id,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString());

      BlocProvider.of<DashboardBloc>(context)
          .add(CreateSession(sessionModel: sessionData));

      context.pop();
    }
  }

  void handleOnJoinSession() {
    final isValidated = _formKey.currentState!.validate();

    if (isValidated) {
      BlocProvider.of<DashboardBloc>(context).add(JoinSession(
        userDetails!.id!,
        code: nameController.text,
      ));
      context.pop();
    }
  }

  void fetchUserSessions() {
    BlocProvider.of<DashboardBloc>(context).add(GetUserDetails());
    Timer(const Duration(seconds: 2), () {
      BlocProvider.of<DashboardBloc>(context)
          .add(FetchUserSessions(id: userDetails!.id!));
    });
  }

  void reinitializeState() {
    isLoading = true;
    fetchUserSessions();
  }

  String generateSessionCode({int length = 9}) {
    final characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.toLowerCase();
    final random = Random();
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('-');
      }
      buffer.write(characters[random.nextInt(characters.length)]);
    }

    return buffer.toString();
  }

  Future<dynamic> openDialog(
      BuildContext context,
      String btnTitle,
      String heading,
      String hintText,
      String errorText,
      VoidCallback onPressed) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: Metrics.width(context) * 0.04,
                left: Metrics.width(context) * 0.04,
                right: Metrics.width(context) * 0.04),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextComponent(
                    text: heading,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: FontSize.xmedium),
                  ),
                  TextFormFieldComponent(
                    controller: nameController,
                    hintText: hintText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return errorText;
                      }
                      // Return null if the input is valid
                      return null;
                    },
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.aquaBlue)),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Metrics.width(context) * 0.04),
                      child: ButtonComponent(
                          btnTitle: btnTitle,
                          btnPadding: const EdgeInsets.all(5),
                          btnStyle: Styles.sessionBtn,
                          btnTextStyle: Styles.btnTextStyle,
                          onPressed: onPressed),
                    ),
                  )
                ],
              ),
            ),
          );
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
          Logger().d(state.isLoading);
          // setState(() {
          //   isLoading=state.isLoading;
          // });
        }
        if (state is DashboardInitial) {}
        if (state is DashboardSuccessState) {
          Logger().d(state.currentUser!.activeSessionId);
          setState(() {
            userDetails = state.currentUser!;
          });
        }
        if (state is SessionLoadingSuccessState) {
          setState(() {
            isLoading = false;
          });
          if (state.userSessions != null && state.userSessions!.isNotEmpty) {
            setState(() {
              userSessions = state.userSessions!;
              isLoading = false;
            });
          }

          Logger().d(state.sessionId);
          if (state.sessionId != null) {
            print('inid');

            context
                .pushNamed(
              NAVIGATION.session,
            )
                .then((val) {
              print('listen called');
              reinitializeState();
            });
          }
        }
        if (state is SessionLoadingErrorState) {
          Logger().d(state.errorMessage);
          Fluttertoast.showToast(
              msg: state.errorMessage!,
              backgroundColor: AppColor.headerBorder,
              textColor: Colors.black);
        }
      },
      builder: (context, state) {
        Logger().d(userDetails!.activeSessionId);
        if (state is DashboardInitial) {
          // Logger().d(state.sessionData);
        }
        if (state is DashboardLoadingState) {
          Logger().d(state.isLoading);
        }

        return Scaffold(
          appBar: AppBar(
            leadingWidth: 30,
            automaticallyImplyLeading: false,
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
                context.pop(context);
              },
            ),
            titleSpacing: 0,
            title: const TextComponent(text: 'Sessions'),
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
                      Expanded(
                        flex: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Metrics.width(context) * 0.04),
                          child: const TextComponent(
                            text: 'Your Sessions',
                            textStyle: TextStyle(
                                fontSize: FontSize.medium,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      userSessions.isNotEmpty
                          ? Expanded(
                              flex: 1,
                              child: ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    SessionModel? sessionItem =
                                        userSessions[index];

                                    Logger().d(sessionItem!.sessionName);
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
                                          onTap: () {
                                            BlocProvider.of<DashboardBloc>(
                                                    context)
                                                .add(JoinSession(
                                                    userDetails!.id!,
                                                    code: sessionItem
                                                        .sessionCode!));
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          title: TextComponent(
                                            text: sessionItem.sessionName ?? '',
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
                                          trailing: TextComponent(
                                            text: sessionItem.id ==
                                                    userDetails!.activeSessionId
                                                ? 'View'
                                                : 'Join',
                                            textStyle: TextStyle(
                                                color: AppColor.white,
                                                fontSize: FontSize.normal),
                                          ),
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
                          : const Expanded(
                              child: Center(
                                child: TextComponent(
                                  text: 'No Sessions Found',
                                ),
                              ),
                            ),
                      FooterComponent(
                        flex: 0,
                        footerMargin: EdgeInsets.symmetric(
                            vertical: Metrics.width(context) * 0.04),
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
                                    nameController.clear();
                                    openDialog(
                                        context,
                                        'Create',
                                        'Add Session Details',
                                        'Enter Session Name',
                                        'Session name cannot be empty',
                                        handleOnCreateSession);
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
                                  // nameController.clear();

                                  openDialog(
                                      context,
                                      'Join',
                                      'Join Session',
                                      'Enter Session Code',
                                      'Session code cannot be empty',
                                      handleOnJoinSession);
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
