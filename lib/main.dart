import 'splash.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(QuickBite());
}

class QuickBite extends StatelessWidget {
  const QuickBite({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      title: 'QuickBite',
      home: SplashView(),
    );
  }
}
