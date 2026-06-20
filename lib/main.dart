import 'package:QuickBite/features/auth/cubit/auth_cubit.dart';
import 'package:QuickBite/features/auth/view/login_view.dart';
import 'package:QuickBite/features/home/cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..getProducts(),
        ),
        BlocProvider(create: (context) => AuthCubit()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        title: 'QuickBite',
        home: SplashView(),
      ),
    );
  }
}
