import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final InputBorder? border;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsets? padding;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final bool? isExpand;
  final bool? filled;
  final Color? fillColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.validator,
    this.border,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.padding,
    this.textInputAction,
    this.textInputType,
    this.textCapitalization,
    this.isExpand,
    this.filled,
    this.fillColor,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      keyboardType: textInputType,
      style: style,
      expands: isExpand ?? false,
      controller: controller,
      cursorHeight: 20,

      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: border,
        focusedErrorBorder: border,
        errorBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border,
        contentPadding: padding,
        hintText: hintText,
        labelText: label,
        floatingLabelStyle: labelStyle,
        hintStyle: hintStyle,
        labelStyle: labelStyle,
        filled: filled,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}
