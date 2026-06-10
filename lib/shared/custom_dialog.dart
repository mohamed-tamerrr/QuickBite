import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 220,
        ),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.card,
        ),
        child: Center(
          child: Column(
            children: [
              Gap(20),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 40,
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              Gap(20),
              CustomText(
                text: 'Success !',
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
              Gap(6),
              Center(
                child: CustomText(
                  text:
                      'Your payment was successful.\nA receipt for this purchase has\nbeen sent to your email.',
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              Gap(50),
              CustomButton(
                text: 'Go Back',
                width: 150,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
