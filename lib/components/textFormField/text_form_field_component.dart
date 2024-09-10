import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:musicmate/constants/index.dart';
import 'styles.dart';

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
  final TextAlign? textAlign;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final Color? focusColor;
  final String? errorText;
  final String? Function(String?)? validator;

  const TextFormFieldComponent({
    super.key,
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
    this.textAlign,
    this.obscureText,
    this.textInputAction,
    this.focusColor,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    Logger().d(errorText);
    return Container(
      // margin: EdgeInsets.symmetric(vertical: Metrics.width(context) * 0.02),
      // height: Metrics.height(context) * 0.15,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        focusNode: focusNode,
        textAlign: TextAlign.left,
        textInputAction: textInputAction,
        obscureText: obscureText ?? false,
        cursorColor: AppColor.black,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: Styles.hintStyle,
            labelStyle: const TextStyle(
                color: AppColor.black, fontWeight: FontWeight.w500),
            errorStyle: Styles.errorStyle,
            // border: InputBorder.none,
            border: border,
            focusedBorder: focusedBorder,
            focusColor: focusColor,
            suffixIcon: suffixIcon,
            suffixIconColor: suffixIconColor ?? AppColor.black,
            hoverColor: Colors.black,
            prefixIcon: prefixIcon,
            prefixIconColor: prefixIconColor),
      ),
    );
  }
}
