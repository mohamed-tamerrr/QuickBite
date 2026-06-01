import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: AppColors.textSecondary.withOpacity(0.25),
      borderRadius: BorderRadius.circular(15),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.card,
          hintText: 'Search...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.card),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.card),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
