import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
  });

  final String hintText;
  final bool isPassword;
  final TextEditingController controller;

  @override
  State<CustomTextFormField> createState() =>
      _CustomTextFormFieldState();
}

class _CustomTextFormFieldState
    extends State<CustomTextFormField> {
  late bool _isObscure;

  @override
  void initState() {
    _isObscure = widget.isPassword;
    super.initState();
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: AppColors.primary,
      cursorHeight: 20,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  _toggleObscure();
                },
                icon: Icon(
                  _isObscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.card),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryLight),
        ),
        filled: true,
        fillColor: AppColors.background,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) {
          return 'Please Enter ${widget.hintText}';
        }
        return null;
      },
      obscureText: _isObscure,
    );
  }
}
