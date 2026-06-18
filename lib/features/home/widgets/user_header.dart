import 'package:QuickBite/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.name,
    required this.image,
  });
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              AppImages.logo,
              height: 90,
              width: 90,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
            Spacer(),
            CircleAvatar(
              radius: 31,
              backgroundColor: AppColors.primary.withValues(
                alpha: 0.2,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, err, builder) =>
                      Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

        Transform.translate(
          offset: Offset(0, -20), // pulls text up closer to logo
          child: CustomText(
            text: 'Hello, $name',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
