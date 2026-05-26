import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/shared/custom_snack.dart';
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
                      isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : AuthBtn(
                              textColor: Colors.white,
                              text: 'Sign Up',
                              onTap: signup,
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
