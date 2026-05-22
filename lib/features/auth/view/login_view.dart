import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/shared/custom_snack.dart';
import '../../../core/constants/app_colors.dart';
import 'signup_view.dart';
import '../widgets/auth_btn.dart';
import '../../../root.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/custom_text_form_field.dart';

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
        ).showSnackBar(customSnack(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : AuthBtn(
                                textColor: Colors.white,
                                text: 'Login',
                                onTap: login,
                              ),
                        Gap(20),
                        AuthBtn(
                          color: Colors.white,
                          text: 'Create an account ?',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SignupView(),
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
