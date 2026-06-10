import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/checkout/data/order_model.dart';
import 'package:hungry/features/checkout/data/order_repo.dart';
import 'package:hungry/shared/custom_dialog.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/order_details_widget.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key, required this.cartItems});
  final List<CartItemModel> cartItems;
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final OrderRepo _orderRepo = OrderRepo();

  Future<void> _saveOrder() async {
    try {
      final orderItems = widget.cartItems.map((item) {
        return OrderItemRequest(
          productId: item.productId,
          quantity: item.quantity,
          spicy: double.tryParse(item.spicyLevel) ?? 0.0,
          toppings: [],
          sideOptions: [],
        );
      }).toList();

      final request = OrderRequest(items: orderItems);

      await _orderRepo.saveOrder(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully'),
        ),
      );
    } catch (e) {
      Failure(errorMassage: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
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
                  activeColor: AppColors.primary,
                  value: true,
                  onChanged: (value) {},
                ),
                CustomText(
                  text: 'Save card details for future payments',
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: AppColors.textPrimary.withOpacity(0.1),
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
                  color: AppColors.textSecondary,
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
              onTap: () async {
                try {
                  await _saveOrder();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomDialog();
                    },
                  );
                } catch (e) {
                  throw Failure(errorMassage: e.toString());
                }
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
          tileColor: AppColors.primaryDark,
          title: const Text(
            'Cash on Delivery',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          leading: Image.asset('assets/cash.png'),
          trailing: Radio<int>(
            activeColor: AppColors.card,
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
          tileColor: AppColors.primary,
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
