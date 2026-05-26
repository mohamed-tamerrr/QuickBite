import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'core/constants/app_colors.dart';
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
  late Animation<Offset> _slideAnimation;
  final AuthRepo _authRepo = AuthRepo();

  /// Auto Login
  Future<void> _checkLogin() async {
    try {
      final user = await _authRepo.autoLogin();
      if (!mounted) return;
      if (_authRepo.isGuest) {
        print('test guest');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      } else if (user != null) {
        print('test');
        print(_authRepo.currentUser);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => Root()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => LoginView()),
        );
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: .8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), _checkLogin);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          const Gap(280),

          /// LOGO ANIMATION
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: SvgPicture.asset('assets/logo/logo.svg'),
            ),
          ),

          const Spacer(),

          /// IMAGE ANIMATION
          SlideTransition(
            position: _slideAnimation,
            child: Image.asset('assets/splash/splash.png'),
          ),
        ],
      ),
    );
  }
}
