import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/auth/widgets/custom_profile_field.dart';
import 'package:hungry/shared/custom_text.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({
    super.key,
    required this.name,
    required this.email,
    required this.address,
    required this.userModel,
    required this.visa,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController address;
  final UserModel? userModel;
  final TextEditingController visa;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomText(
            text: 'Account info',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const Gap(18),

          /// Name
          CustomProfileField(label: 'Name', controller: name),
          const Gap(16),

          /// Email
          CustomProfileField(label: 'Email', controller: email),
          const Gap(16),

          /// Address
          CustomProfileField(
            label: 'Address',
            controller: address,
          ),
          const Gap(16),
          Divider(
            color: AppColors.textSecondary.withValues(
              alpha: 0.28,
            ),
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
          userModel?.visa == null || userModel!.visa!.isEmpty
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tileColor: AppColors.background,
                  title: const CustomText(
                    text: 'Visa',
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                  subtitle: CustomText(
                    text: userModel!.visa!,
                    fontSize: 16,
                    color: AppColors.textSecondary,
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
    );
  }
}
