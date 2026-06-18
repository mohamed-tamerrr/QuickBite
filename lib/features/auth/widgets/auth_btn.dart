// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:QuickBite/core/constants/app_colors.dart';
import 'package:QuickBite/shared/custom_text.dart';
import 'package:flutter/material.dart';

class AuthBtn extends StatelessWidget {
  const AuthBtn({
    Key? key,

    required this.text,
    required this.onTap,
    this.textColor,
    this.color,
    this.borderColor,
  }) : super(key: key);

  final String text;
  final void Function() onTap;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.white),
          borderRadius: BorderRadius.circular(7),
          color: color ?? AppColors.primary,
        ),
        height: 55,
        width: double.infinity,
        child: Center(
          child: CustomText(
            fontSize: 15,
            text: text,
            fontWeight: FontWeight.w800,
            color: textColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
