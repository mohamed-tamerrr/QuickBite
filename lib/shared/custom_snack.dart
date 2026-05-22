import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'custom_text.dart';

SnackBar customSnack(String errorMsg) {
  return SnackBar(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    margin: const EdgeInsets.only(
      bottom: 30,
      right: 20,
      left: 20,
    ),
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red.shade900,
    content: Row(
      children: [
        const Icon(CupertinoIcons.info, color: Colors.white),
        const Gap(14),
        Expanded(
          child: CustomText(
            text: errorMsg,
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
