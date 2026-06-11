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
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(30),
            SvgPicture.asset(
              'assets/logo/logo.svg',
              colorFilter: ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
              height: 35,
            ),
            Gap(5),
            CustomText(
              text: 'Hello, $name',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ],
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
    );
  }
}
