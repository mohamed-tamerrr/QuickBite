import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/cart/widgets/cart_item.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(60),

            /// Title
            Row(
              children: const [
                CustomText(
                  text: "Order History",
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            /// Cart Items List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 10),
                itemCount: 8,
                separatorBuilder: (_, __) => const Gap(15),
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/cart.png'),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: 'Pizza Margherita',
                                  ),
                                  CustomText(
                                    text: 'Quantity: 2',
                                  ),
                                  CustomText(
                                    text: 'Total: \$12.99',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(20),
                          CustomButton(
                            text: 'Re order',
                            onTap: () {},
                            color: Colors.grey.shade400,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
