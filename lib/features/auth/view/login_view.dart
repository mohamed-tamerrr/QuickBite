import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/core/utils/app_images.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../root.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/custom_text_form_field.dart';
import '../widgets/auth_btn.dart';
import 'signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isLoading = false;
  final AuthRepo authRepo = AuthRepo();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Login
  Future<void> login() async {
    setState(() => isLoading = true);
    if (formKey.currentState!.validate()) {
      try {
        final user = await authRepo.login(
          email: email.text.trim(),
          password: password.text.trim(),
        );
        if (user != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Root()),
          );
          setState(() => isLoading = false);
        }
      } catch (e) {
        setState(() => isLoading = false);
        String error = 'unhandled error';
        if (e is Failure) {
          error = e.toString();
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(customSnack(msg: error));
      }
    }
  }

  @override
  void initState() {
    email.text = "mohamed.tamer@gmail.com";
    password.text = "123456789";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// Logo
                  Center(
                    child: Image.asset(
                      AppImages.logo,
                      color: AppColors.primary,
                      width: 100,
                    ),
                  ),

                  Center(
                    child: CustomText(
                      text: 'Welcome Back',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(8),
                  Center(
                    child: CustomText(
                      text: 'Discover the best food around you',
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(28),

                  /// Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimary
                              .withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        CustomText(
                          text: 'Sign in to continue',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        const Gap(24),

                        /// Email
                        CustomTextFormField(
                          controller: email,
                          hintText: 'Email Address',
                          isPassword: false,
                        ),
                        const Gap(18),

                        /// Password
                        CustomTextFormField(
                          controller: password,
                          hintText: 'Password',
                          isPassword: true,
                        ),
                        const Gap(24),
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            :
                              /// Login
                              AuthBtn(
                                textColor: Colors.white,
                                text: 'Login',
                                onTap: login,
                              ),
                        const Gap(16),

                        /// Creat Account
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignupView(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary
                                .withValues(alpha: .08),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          child: const CustomText(
                            text: 'Create an account ?',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
