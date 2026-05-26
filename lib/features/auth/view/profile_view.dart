import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/view/login_view.dart';
import 'package:hungry/shared/custom_button.dart';
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
      color: Colors.red,
      onRefresh: () async {
        await getProfileData();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.primary,
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
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),
                child: SvgPicture.asset(
                  'assets/settings.svg',
                  width: 20,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Skeletonizer(
                enabled: userModel == null,
                child: Column(
                  children: [
                    /// Image
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                        ),
                        child: selectedImage != null
                            ? Image(
                                image: FileImage(
                                  File(selectedImage!),
                                ),
                              )
                            : userModel?.image != null &&
                                  userModel!.image!.isNotEmpty
                            ? Image.network(
                                userModel!.image!,
                                errorBuilder:
                                    (
                                      context,
                                      error,
                                      stackTrace,
                                    ) => Icon(Icons.person),
                              )
                            : Icon(Icons.person),
                      ),
                    ),
                    Gap(10),

                    /// Upload Image
                    CustomButton(
                      onTap: pickImage,
                      width: 200,
                      text: 'Upload Image',
                      color: Colors.deepPurple,
                    ),
                    Gap(20),

                    /// Name
                    CustomProfileField(
                      label: 'Name',
                      controller: name,
                    ),
                    Gap(20),

                    /// Email
                    CustomProfileField(
                      label: 'Email',
                      controller: email,
                    ),
                    Gap(20),

                    /// Address
                    CustomProfileField(
                      label: 'Address',
                      controller: address,
                    ),
                    Gap(20),

                    Divider(color: Colors.white, thickness: 1),

                    Gap(8),
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
                                  BorderRadius.circular(20),
                            ),
                            tileColor: Colors.white,
                            title: const CustomText(
                              text: 'Visa',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            subtitle: const CustomText(
                              text: '**** **** **** 1234',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            leading: Image.asset(
                              'assets/profile_visa.png',
                              width: 80,
                            ),
                            trailing: CustomText(
                              text: 'Default',
                              color: Colors.black,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),

          bottomSheet: Container(
            height: 90,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Left Button: "Edit Profile"
                GestureDetector(
                  onTap: updataProfileData,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Row(
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
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
                SizedBox(width: 16), // Space between buttons
                // Right Button: "Log out"
                GestureDetector(
                  onTap: logout,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Log out",
                          style: TextStyle(
                            color: AppColors.primary,
                          ),
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

class CustomProfileField extends StatelessWidget {
  const CustomProfileField({
    super.key,
    this.label,
    required this.controller,
  });
  final String? label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
      ),
    );
  }
}
