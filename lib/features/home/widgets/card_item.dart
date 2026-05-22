import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_text.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    super.key,
    required this.rate,
    required this.desc,
    required this.text,
    required this.image,
  });
  final String rate, desc, text, image;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(image, width: 180),
            Gap(10),
            CustomText(text: text, fontWeight: FontWeight.bold),
            CustomText(text: desc, fontWeight: FontWeight.bold),
            Row(
              children: [
                CustomText(text: '⭐  $rate'),
                Spacer(),
                Icon(
                  Icons.favorite,
                  color: AppColors.primary,
                  // size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
