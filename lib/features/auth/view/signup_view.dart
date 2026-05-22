import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/auth_btn.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/custom_text_form_field.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword =
        TextEditingController();
    TextEditingController name = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: Form(
          child: Column(
            children: [
              Gap(200),
              SvgPicture.asset(
                'assets/logo/logo.svg',
                color: AppColors.primary,
              ),
              Gap(10),
              CustomText(text: 'Welcome to our Food App !!'),
              Gap(60),
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
                        controller: name,
                        hintText: 'Full Name',
                        isPassword: false,
                      ),
                      Gap(15),
                      CustomTextFormField(
                        controller: email,
                        hintText: 'Email Address',
                        isPassword: false,
                      ),
                      Gap(15),
                      CustomTextFormField(
                        controller: password,
                        hintText: 'Password',
                        isPassword: true,
                      ),
                      Gap(15),
                      CustomTextFormField(
                        controller: confirmPassword,
                        hintText: 'Confirm Password',
                        isPassword: true,
                      ),
                      Gap(30),
                      AuthBtn(
                        textColor: Colors.white,
                        text: 'Sign Up',
                        onTap: () {
                          if (formKey.currentState!
                              .validate()) {}
                        },
                      ),
                      Gap(20),
                      AuthBtn(
                        color: Colors.white,
                        textColor: AppColors.primary,
                        text: 'Go To Login ?',
                        onTap: () {
                          Navigator.pop(context);
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
    );
  }
}
