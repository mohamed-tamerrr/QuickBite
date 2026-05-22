import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
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

  @override
  void initState() {
    name.text = 'Mohamed Tamer';
    email.text = 'mohamed.tamer@example.com';
    address.text = '123 Main Street, City, Country';
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          children: [
            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white,
                    width: 5,
                  ),
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            Gap(20),
            CustomProfileField(label: 'Name', controller: name),
            Gap(20),
            CustomProfileField(
              label: 'Email',
              controller: email,
            ),
            Gap(20),
            CustomProfileField(
              label: 'Address',
              controller: address,
            ),
            Gap(20),

            Divider(color: Colors.white, thickness: 1),

            Gap(8),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
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

      bottomSheet: Container(
        height: 90,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left Button: "Edit Profile"
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.edit, color: Colors.white),
                ],
              ),
            ),
            SizedBox(width: 16), // Space between buttons
            // Right Button: "Log out"
            Container(
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
                    style: TextStyle(color: AppColors.primary),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.logout, color: AppColors.primary),
                ],
              ),
            ),
          ],
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
