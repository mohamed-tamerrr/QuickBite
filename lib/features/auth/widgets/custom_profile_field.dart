import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class CustomProfileField extends StatelessWidget {
  const CustomProfileField({
    super.key,
    this.label,
    required this.controller,
  });
  final String? label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: AppColors.primary,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.card,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
