import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/product/view/product_details_view.dart';
import 'package:hungry/features/product/widgets/custom_button_product_details.dart';
import 'package:hungry/shared/custom_text.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,

    this.isLoading = false,
    this.onTap,

    required this.body,
  });

  final bool isLoading;
  final void Function()? onTap;

  final Widget? body;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.card,
        gradient: LinearGradient(
          colors: AppColors.gradientsPrimary,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: body,
    );
  }
}
