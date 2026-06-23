import 'package:QuickBite/core/utils/app_images.dart';
import 'package:QuickBite/features/auth/cubit/auth_cubit.dart';
import 'package:QuickBite/features/auth/view/login_view.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword =
      TextEditingController();
  final TextEditingController name = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(
              msg: 'REGISTERED SUCCESSFULLY',
              color: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginView()),
          );
        }
        if (state is SignupFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(customSnack(msg: state.errorMsg));
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Please Enter Confirm Password';
                              }
                              if (value != password.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const Gap(24),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final cubit = context
                                  .read<AuthCubit>();
                              return state is SignupLoading
                                  ? const Center(
                                      child:
                                          CircularProgressIndicator(
                                            color: AppColors
                                                .primary,
                                          ),
                                    )
                                  : AuthBtn(
                                      textColor: Colors.white,
                                      text: 'Sign Up',
                                      onTap: () {
                                        if (formKey.currentState!
                                            .validate()) {
                                          cubit.signup(
                                            email: email.text
                                                .trim(),
                                            password: password
                                                .text
                                                .trim(),
                                            name: name.text,
                                          );
                                        }
                                      },
                                    );
                            },
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
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                              foregroundColor: AppColors.primary,
                              padding:
                                  const EdgeInsets.symmetric(
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
        ),
      ),
    );
  }
}
