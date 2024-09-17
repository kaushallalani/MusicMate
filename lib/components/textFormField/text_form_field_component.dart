import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/constants/index.dart';
import 'styles.dart';

import 'package:flutter/material.dart';

class TextFormFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final String? hintText;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final InputBorder? focusedBorder;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final InputBorder? border;
  final OutlineInputBorder? enabledBorder;
  final TextAlign? textAlign;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final Color? focusColor;
  final String? errorText;
  final String? Function(String?)? validator;
  final SizedBox? containerSize;
  final bool? isRequired;
  final String? title;
  final TextStyle? inputTextStyle;
  final Function(String)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final bool? isReadOnly;
  final bool? isFilled;
  final Color? fillColor;
  final void Function()? onTap;
  final EdgeInsetsGeometry? contentPadding;

  const TextFormFieldComponent(
      {super.key,
      required this.controller,
      this.keyboardType,
      this.focusNode,
      this.onFieldSubmitted,
      this.hintText,
      this.labelText,
      this.labelStyle,
      this.hintStyle,
      this.focusedBorder,
      this.suffixIcon,
      this.suffixIconColor,
      this.prefixIcon,
      this.prefixIconColor,
      this.border,
      this.enabledBorder,
      this.textAlign,
      this.obscureText,
      this.textInputAction,
      this.focusColor,
      this.errorText,
      this.validator,
      this.containerSize,
      this.isRequired,
      this.title,
      this.inputTextStyle,
      this.onChanged,
      this.autovalidateMode,
      this.isReadOnly,
      this.isFilled,
      this.fillColor,
      this.onTap,
      this.contentPadding});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = Metrics.isTablet(context);
    final isPortrait = Metrics.isPortrait(context);
    return Container(
      alignment: Alignment.center,
      width: containerSize?.width,
      // height: containerSize?.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null
              ? Padding(
                  padding: EdgeInsets.only(
                      top: Metrics.width(context) * 0.02,
                      bottom: Metrics.width(context) * 0.02),
                  child: RichText(
                      textScaler: isTablet == true
                          ? isPortrait
                              ? const TextScaler.linear(0.6)
                              : const TextScaler.linear(0.4)
                          : const TextScaler.linear(1),
                      text: TextSpan(
                          text: title,
                          style: Styles.titleText(context).copyWith(
                              fontSize: Metrics.getFontSize(
                                  context,
                                  isTablet && !isPortrait
                                      ? 25
                                      : FontSize.normal)),
                          children: [
                            isRequired!
                                ? TextSpan(
                                    text: '*', style: Styles.subText(context))
                                : const TextSpan()
                          ])),
                )
              : Container(),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            focusNode: focusNode,
            textAlign: TextAlign.left,
            onTap: onTap,
            textInputAction: textInputAction,
            obscureText: obscureText ?? false,
            cursorColor: theme.customColors.bgInverse,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            style: Styles.inputTextStyle(context).merge(inputTextStyle),
            onChanged: onChanged,
            autovalidateMode: autovalidateMode,
            readOnly: isReadOnly ?? false,
            minLines: 1,
            maxLines: null,
            decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                fillColor: fillColor,
                filled: isFilled,
                hintStyle: Styles.hintStyle(context).copyWith(
                    fontSize: Metrics.getFontSize(
                        context,
                        isTablet && !isPortrait
                            ? FontSize.xxsmall
                            : FontSize.snormal)),
                labelStyle: TextStyle(
                    color: theme.customColors.bgInverse,
                    fontWeight: FontWeight.w500),
                errorStyle: isTablet == true
                    ? Styles.errorStyle(context).copyWith(
                        fontSize: Metrics.getFontSize(
                            context,
                            isTablet && !isPortrait
                                ? FontSize.xxsmall
                                : FontSize.smallest))
                    : Styles.errorStyle(context),
                border: border,
                enabledBorder: enabledBorder,
                focusedBorder: focusedBorder,
                errorBorder: Styles.errorBorder(context),
                focusedErrorBorder: Styles.errorBorder(context),
                focusColor: focusColor,
                suffixIcon: suffixIcon,
                suffixIconColor:
                    suffixIconColor ?? theme.customColors.bgInverse,
                hoverColor: theme.customColors.blackColor,
                prefixIcon: prefixIcon,
                prefix: prefixIcon == null
                    ? const Padding(
                        padding: EdgeInsets.only(left: Metrics.semiBaseMargin),
                      )
                    : null,
                contentPadding: contentPadding ??
                    (isTablet
                        ? const EdgeInsets.fromLTRB(0, 15, 15, 15)
                        : const EdgeInsets.only(left: 0, right: 5)),
                prefixIconColor: prefixIconColor),
          ),
        ],
      ),
    );
  }
}
