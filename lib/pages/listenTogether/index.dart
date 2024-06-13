import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'styles.dart';

class ListenTogether extends StatefulWidget {
  const ListenTogether({super.key});

  @override
  State<ListenTogether> createState() => _ListenTogetherState();
}

class _ListenTogetherState extends State<ListenTogether> {
  void handleOnSessionCreate() {}
  final TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> errors;

  @override
  void initState() {
    super.initState();
    errors = {};
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
  }

  @override
  Widget build(BuildContext context) {
    Logger().d(errors);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Entypo.left_open_big,
            size: 20,
          ),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(Metrics.width(context) * 0.04),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonComponent(
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
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
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
                                    const TextComponent(
                                      text: 'Add Session Details',
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: FontSize.xmedium),
                                    ),
                                    TextFormFieldComponent(
                                      controller: nameController,
                                      hintText: 'Enter Session Name',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Session name cannot be empty';
                                        }
                                        // Return null if the input is valid
                                        return null;
                                      },
                                      
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColor.aquaBlue)),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                Metrics.width(context) * 0.04),
                                        child: ButtonComponent(
                                          btnTitle: 'Create',
                                          btnPadding: const EdgeInsets.all(5),
                                          btnStyle: Styles.sessionBtn,
                                          btnTextStyle: Styles.btnTextStyle,
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
            )
          ],
        ),
      ),
    );
  }
}
