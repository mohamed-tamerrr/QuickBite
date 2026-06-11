import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_text.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
  });

  final String order, taxes, fees, total;

  Widget checkWidget(String title, price, isBold, isSmall) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: title,
          color: isBold ? Colors.black : Colors.grey.shade600,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          fontSize: isSmall ? 14 : 18,
        ),
        CustomText(
          text: price,
          color: isBold ? Colors.black : Colors.grey.shade600,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
          fontSize: isSmall ? 14 : 18,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        checkWidget('Order', order, false, false),
        Gap(10),
        checkWidget('Taxes', taxes, false, false),
        Gap(10),
        checkWidget('Delivery fees', fees, false, false),
        Divider(color: Color(0xffF0F0F0)),
        Gap(20),
        checkWidget('Total', total, true, false),
        Gap(20),
        checkWidget(
          'Estimated delivery time:',
          '15 - 30 mins',
          true,
          true,
        ),
      ],
    );
  }
}
