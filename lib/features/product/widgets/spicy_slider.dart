import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text:
              'Customize Your Burger to Your Tastes.\nUltimate Experience',
        ),
        Slider(
          activeColor: AppColors.primary,
          inactiveColor: AppColors.primary.withValues(alpha: .5),
          min: 0,
          max: 1,
          value: value,
          onChanged: onChanged,
        ),
        Row(
          children: [
            CustomText(text: '🥶'),
            Spacer(),
            CustomText(text: '🌶️'),
          ],
        ),
      ],
    );
  }
}
