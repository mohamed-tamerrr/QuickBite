import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/core/utils/app_images.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../widgets/auth_btn.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/custom_text_form_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword =
      TextEditingController();
  TextEditingController name = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthRepo authRepo = AuthRepo();
  bool isLoading = false;

  /// Sign Up
  Future<void> signup() async {
    setState(() => isLoading = true);
    if (formKey.currentState!.validate()) {
      try {
        final user = await authRepo.signup(
          email: email.text.trim(),
          password: password.text.trim(),
          name: name.text.trim(),
        );
        if (user != null) {
          Navigator.pop(context);
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                    text: 'Create Account',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Gap(8),
                Center(
                  child: CustomText(
                    text:
                        'Join us and order your favorite meals',
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
                        color: AppColors.textPrimary.withValues(
                          alpha: 0.08,
                        ),
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
                        text: 'Start your journey',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      const Gap(24),

                      /// Name
                      CustomTextFormField(
                        controller: name,
                        hintText: 'Full Name',
                        isPassword: false,
                      ),
                      const Gap(18),

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
                      const Gap(18),

                      /// Confirm Password
                      CustomTextFormField(
                        controller: confirmPassword,
                        hintText: 'Confirm Password',
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
                            /// Sign Up
                            AuthBtn(
                              textColor: Colors.white,
                              text: 'Sign Up',
                              onTap: signup,
                            ),
                      const Gap(16),

                      /// Go To Login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary
                              .withValues(alpha: .08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16,
                            ),
                          ),
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                        child: const CustomText(
                          text: 'Go To Login ?',
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
    );
  }
}
