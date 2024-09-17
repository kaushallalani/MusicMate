import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

void showCustomToast({
  required BuildContext context,
  required FToast fToast,
  required List<String> message,
  Color? backgroundColor,
  IconData? icon,
  double? width,
  double? height,
  double? top,
  double? right,
  Duration toastDuration = const Duration(seconds: 2),
  AnimationType animationType = AnimationType.slide,
}) {
  final colors = Theme.of(context).customColors;
  final isTablet = Metrics.isTablet(context);
  final isPortrait = Metrics.isPortrait(context);

  Widget createToast(String message, List<String> messageList) {
    return Container(
      margin: const EdgeInsets.all(Metrics.baseMargin),
      child: Container(
        padding: const EdgeInsets.all(Metrics.baseMargin),
        constraints: isTablet
            ? null
            : BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(Metrics.borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Icon(icon, size: 30, color: colors.whiteColor)
                : Container(),
            // const SizedBox(width: Metrics.baseMargin),
            Flexible(
              child: Text(
                message,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: isTablet
                      ? isPortrait
                          ? Metrics.getFontSize(context, 14)
                          : Metrics.getFontSize(context, 20)
                      : Metrics.getFontSize(context, 14),
                  color: colors.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display all toasts
  fToast.showToast(
    toastDuration: toastDuration,
    positionedToastBuilder: (context, child) {
      return Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        // top: top ?? 50.0,
        // right: right ?? 0.0,
        child: child,
      );
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < message.length; i++)
          CustomAnimatedWidget(
            animationType: animationType,
            displayDuration: toastDuration,
            child: createToast(message[i], message),
          ),
      ],
    ),
  );
}

customModalSheet(
    {required BuildContext context,
    required Widget children,
    required bool isScrollControlled,
    required Color backgroundColor,
    ShapeBorder? shape,
    AnimationStyle? sheetAnimationStyle}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      shape: shape,
      sheetAnimationStyle: sheetAnimationStyle,
      builder: (BuildContext context) {
        return children;
      });
}

DateTime dateFromTimestamp(int? timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp!);
}
