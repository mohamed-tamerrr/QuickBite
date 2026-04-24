import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/auth/widgets/auth_btn.dart';
import 'package:hungry/shared/custom_text_form_field.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),

          child: Form(
            child: Column(
              children: [
                Gap(100),
                SvgPicture.asset('assets/logo/logo.svg'),
                Gap(60),
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
                  text: 'Sign Up',
                  onTap: () {
                    if (formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
