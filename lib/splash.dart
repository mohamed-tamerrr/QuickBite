import 'package:QuickBite/core/constants/app_colors.dart';
import 'package:QuickBite/core/utils/app_images.dart';
import 'package:QuickBite/features/auth/cubit/auth_cubit.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/view/login_view.dart';
import 'root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _floatAnimation;

  final AuthRepo _authRepo = AuthRepo();

  Future<void> _checkLogin() async {
    try {
      final user = await _authRepo.autoLogin();

      if (!mounted) return;

      if (_authRepo.isGuest || user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Root()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
              child: const LoginView(),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => AuthCubit(),
              child: const LoginView(),
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _floatAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.02),
          end: const Offset(0, -0.02),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );

    _controller.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), _checkLogin);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientsSplash,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _floatAnimation,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(
                        alpha: 0.25,
                      ),
                      blurRadius: 80,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    AppImages.logo,
                    color: Colors.white,
                    width: 240,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
