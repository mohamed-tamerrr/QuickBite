// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class AuthBtn extends StatelessWidget {
  const AuthBtn({
    Key? key,

    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        height: 55,
        width: double.infinity,
        child: Center(
          child: CustomText(
            fontSize: 15,
            text: text,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
