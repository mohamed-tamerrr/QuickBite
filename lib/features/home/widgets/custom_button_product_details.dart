import 'package:QuickBite/core/constants/app_colors.dart';
import 'package:QuickBite/shared/custom_text.dart';
import 'package:flutter/material.dart';

class CustomProductDetailsButton extends StatefulWidget {
  const CustomProductDetailsButton({
    super.key,
    required this.text,
    this.onTap,
    this.color,
    this.width,
    this.isLoading = false,
    this.textColor,
    this.iconColor,
  });
  final String text;
  final void Function()? onTap;
  final Color? color;
  final Color? textColor;
  final Color? iconColor;
  final double? width;
  final bool isLoading;

  @override
  State<CustomProductDetailsButton> createState() =>
      _CustomProductDetailsButtonState();
}

class _CustomProductDetailsButtonState
    extends State<CustomProductDetailsButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height: 50,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          // vertical: 15,
        ),
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: widget.text,
              fontSize: 20,
              color: widget.textColor ?? Colors.white,
            ),
            const SizedBox(width: 10),
            widget.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Icon(
                    Icons.shopping_cart_outlined,
                    color: widget.iconColor ?? Colors.white,
                  ),
          ],
        ),
      ),
    );
  }
}
