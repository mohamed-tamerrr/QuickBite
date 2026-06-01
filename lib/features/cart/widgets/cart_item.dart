import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.text,
    required this.desc,
    required this.image,
    this.onAdd,
    this.onRemove,
    this.onMinus,
    required this.quantity,
  });
  final String text, desc, image;
  final Function()? onAdd;
  final Function()? onMinus;
  final Function()? onRemove;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(image),
                CustomText(
                  text: text,
                  fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: desc,
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onMinus,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Gap(30),
                    CustomText(
                      text: quantity.toString(),
                      fontSize: 20,
                    ),
                    const Gap(30),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(30),

                Container(
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: CustomText(
                      text: 'Remove',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
