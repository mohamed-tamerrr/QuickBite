import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/features/auth/widgets/custom_profile_field.dart';
import 'package:hungry/shared/custom_snack.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController visa = TextEditingController();
  bool isLoading = false;

  String? selectedImage;
  UserModel? userModel;
  final AuthRepo _authRepo = AuthRepo();

  @override
  void initState() {
    getProfileData().then((value) {
      name.text = userModel?.name ?? 'Mohamed Tamer';
      email.text =
          userModel?.email ?? 'mohamed.tamer@example.com';
      address.text =
          userModel?.address ?? '123 Main Street, City, Country';
    });

    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    address.dispose();
    super.dispose();
  }

  /// Pick Image
  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      selectedImage = pickedImage.path;
    }
  }

  /// GetProfile
  Future<void> getProfileData() async {
    try {
      final user = await _authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String error = 'Error in profile';
      if (e is Failure) {
        error = e.errorMassage;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnack(msg: error));
    }
  }

  /// Update Profile
  Future<void> updataProfileData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final user = await _authRepo.updateProfile(
        name: name.text.trim(),
        email: email.text.trim(),
        address: address.text.trim(),
        visa: visa.text.trim(),
        image: selectedImage,
      );
      setState(() {
        userModel = user;
        isLoading = false;
      });
      await getProfileData();
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(msg: 'Profile Updated', color: Colors.green),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      String errMsg = 'Error';
      if (e is Failure) errMsg = e.errorMassage;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnack(msg: errMsg));
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _authRepo.logout();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(msg: e.toString(), color: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await getProfileData();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            title: const CustomText(text: 'Profile'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),

                /// Settings
                child: SvgPicture.asset(
                  'assets/settings.svg',
                  width: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Skeletonizer(
                enabled: userModel == null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      ///   profile picture
                      child: Stack(
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
                                        userModel!
                                            .image!
                                            .isNotEmpty
                                  ? Image.network(
                                      userModel!.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: AppColors
                                                .textSecondary,
                                          ),
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors
                                          .textSecondary,
                                    ),
                            ),
                          ),

                          /// Pick Image
                          GestureDetector(
                            onTap: pickImage,
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
                      ),
                    ),
                    const Gap(16),
                    CustomText(
                      text: 'My Profile',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    const Gap(8),
                    CustomText(
                      text:
                          'Manage your personal information, payment cards and account preferences.',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    const Gap(24),

                    /// Info
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary
                                .withValues(alpha: 0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          CustomText(
                            text: 'Account info',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          const Gap(18),

                          /// Name
                          CustomProfileField(
                            label: 'Name',
                            controller: name,
                          ),
                          const Gap(16),

                          /// Email
                          CustomProfileField(
                            label: 'Email',
                            controller: email,
                          ),
                          const Gap(16),

                          /// Address
                          CustomProfileField(
                            label: 'Address',
                            controller: address,
                          ),
                          const Gap(16),
                          Divider(
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.28),
                            thickness: 1,
                          ),
                          const Gap(16),
                          CustomText(
                            text: 'Payment method',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          const Gap(16),
                          userModel?.visa == null ||
                                  userModel!.visa!.isEmpty
                              ?
                                /// Add Visa
                                CustomProfileField(
                                  label: 'Add Visa Card',
                                  controller: visa,
                                )
                              :
                                /// Visa Card
                                ListTile(
                                  onTap: () {},
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 5,
                                      ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          20,
                                        ),
                                  ),
                                  tileColor:
                                      AppColors.background,
                                  title: const CustomText(
                                    text: 'Visa',
                                    fontSize: 20,
                                    color: AppColors.textPrimary,
                                  ),
                                  subtitle: const CustomText(
                                    text: '**** **** **** 1234',
                                    fontSize: 16,
                                    color:
                                        AppColors.textSecondary,
                                  ),
                                  leading: Image.asset(
                                    'assets/profile_visa.png',
                                    width: 80,
                                  ),
                                  trailing: const CustomText(
                                    text: 'Default',
                                    color: AppColors.primary,
                                  ),
                                ),
                          Gap(400),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          bottomSheet: Container(
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.card,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: updataProfileData,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            children: const [
                              CustomText(
                                text: 'Edit Profile',
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: logout,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: const [
                        CustomText(
                          text: 'Log out',
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.logout,
                          color: AppColors.primary,
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
