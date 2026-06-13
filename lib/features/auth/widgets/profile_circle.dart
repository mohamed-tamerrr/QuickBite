import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/data/user_model.dart';

class ProfileCircle extends StatelessWidget {
  const ProfileCircle({
    super.key,
    required this.selectedImage,
    required this.userModel,
    this.onTap,
  });

  final String? selectedImage;
  final UserModel? userModel;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 130,
          width: 130,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
            shape: BoxShape.circle,
            color: AppColors.card,
          ),
          child: ClipOval(
            child: selectedImage != null
                ? Image.file(
                    File(selectedImage!),
                    fit: BoxFit.cover,
                  )
                : userModel?.image != null &&
                      userModel!.image!.isNotEmpty
                ? Image.network(
                    userModel!.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.textSecondary,
                        ),
                  )
                : const Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.textSecondary,
                  ),
          ),
        ),

        /// Pick Image
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
