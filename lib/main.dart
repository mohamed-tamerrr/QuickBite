import 'package:flutter/material.dart';

import 'package:hungry/features/auth/view/signup_view.dart';
import 'package:hungry/splash.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(Hungry());
}

class Hungry extends StatelessWidget {
  const Hungry({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      title: 'Hungry',
      home: SplashView(),
    );
  }
}
