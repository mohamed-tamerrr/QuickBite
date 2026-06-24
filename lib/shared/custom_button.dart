import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.color,
    this.textColor,
    this.width,
  });

  final String? text;
  final Widget? child;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;
    final buttonColor = (color ?? AppColors.primary).withOpacity(
      isDisabled ? 0.5 : 1.0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child:
              child ??
              CustomText(
                text: text ?? '',
                fontSize: 20,
                color: textColor,
              ),
        ),
      ),
    );
  }
}
