import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
  });
  final String text;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          // vertical: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: CustomText(
            text: text,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
