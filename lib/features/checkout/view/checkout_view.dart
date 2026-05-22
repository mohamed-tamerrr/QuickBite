import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/order_details_widget.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Order Summary',
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            Gap(20),
            OrderDetailsWidget(
              order: '\$15.46',
              taxes: '\$0.3',
              fees: '\$0.3',
              total: '\$16.06',
            ),
            Gap(60),
            CustomText(
              text: 'Payment methods',
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            Gap(20),
            PaymentMethodView(),

            Row(
              children: [
                Checkbox(
                  activeColor: Color(0xffEF2A39),
                  value: true,
                  onChanged: (value) {},
                ),
                CustomText(
                  text: 'Save card details for future payments',
                ),
              ],
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, -3),
            ),
          ],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        height: 120,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Total Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(
                  text: 'Total',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                CustomText(
                  text: '\$45.00',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            /// Checkout Button
            CustomButton(
              text: 'Pay Now',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 220,
                        ),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Gap(20),
                              CircleAvatar(
                                backgroundColor:
                                    AppColors.primary,
                                radius: 40,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              Gap(20),
                              CustomText(
                                text: 'Success !',
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                              Gap(6),
                              Center(
                                child: CustomText(
                                  text:
                                      'Your payment was successful.\nA receipt for this purchase has\nbeen sent to your email.',
                                  fontSize: 16,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              Gap(50),
                              CustomButton(
                                text: 'Go Back',
                                width: 150,
                                onTap: () =>
                                    Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView({super.key});

  @override
  State<PaymentMethodView> createState() =>
      _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  int selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => setState(() => selectedValue = 1),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: const Color(0xff3C2F2F),
          title: const Text(
            'Cash on Delivery',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: Image.asset('assets/cash.png'),
          trailing: Radio<int>(
            activeColor: Colors.white,
            value: 1,
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
            },
          ),
        ),

        const Gap(20),

        ListTile(
          onTap: () => setState(() => selectedValue = 2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tileColor: Colors.blue.shade900,
          title: const CustomText(
            text: 'Visa',
            fontSize: 20,
            color: Colors.white,
          ),
          subtitle: const CustomText(
            text: '**** **** **** 1234',
            fontSize: 16,
            color: Colors.white,
          ),
          leading: Image.asset('assets/visa.png'),
          trailing: Radio<int>(
            activeColor: Colors.white,
            value: 2,
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
            },
          ),
        ),
      ],
    );
  }
}
