import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/shared/custom_text.dart';

class SpicySlider extends StatelessWidget {
  const SpicySlider({
    super.key,
    required this.value,
    this.onChanged,
  });
  final double value;
  final void Function(double)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/detail.png', width: 200),
        Spacer(),
        Column(
          children: [
            CustomText(
              text:
                  'Customize Your Burger\nto Your Tastes.Ultimate\nExperience',
            ),
            Slider(
              activeColor: AppColors.primary,
              inactiveColor: AppColors.primary.withValues(
                alpha: .5,
              ),
              min: 0,
              max: 1,
              value: value,
              onChanged: onChanged,
            ),
            Row(
              children: [
                CustomText(text: '🥶'),
                Gap(100),
                CustomText(text: '🌶️'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
