import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Gap(280),
          SvgPicture.asset('assets/logo/logo.svg'),
          Spacer(),
          Image.asset('assets/splash/splash.png'),
        ],
      ),
    );
  }
}
