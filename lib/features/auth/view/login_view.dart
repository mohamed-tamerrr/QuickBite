import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/view/signup_view.dart';
import 'package:hungry/features/auth/widgets/auth_btn.dart';
import 'package:hungry/root.dart';
import 'package:hungry/shared/custom_text.dart';
import 'package:hungry/shared/custom_text_form_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Gap(200),
                SvgPicture.asset(
                  'assets/logo/logo.svg',
                  color: AppColors.primary,
                ),
                Gap(10),
                CustomText(
                  text:
                      'Welcome Back , Discover the best food around you',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
                Gap(70),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: AppColors.primary,
                    ),
                    child: Column(
                      children: [
                        Gap(30),
                        CustomTextFormField(
                          controller: email,
                          hintText: 'Email Address',
                          isPassword: false,
                        ),
                        Gap(20),
                        CustomTextFormField(
                          controller: password,
                          hintText: 'Password',
                          isPassword: true,
                        ),
                        Gap(30),
                        AuthBtn(
                          textColor: Colors.white,
                          text: 'Login',
                          onTap: () {
                            if (formKey.currentState!
                                .validate()) {}
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Root(),
                              ),
                            );
                          },
                        ),
                        Gap(20),
                        AuthBtn(
                          color: Colors.white,
                          text: 'Create an account ?',
                          onTap: () {
                            if (formKey.currentState!
                                .validate()) {}
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignupView(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
