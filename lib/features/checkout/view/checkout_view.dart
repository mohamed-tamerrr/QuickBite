import 'package:QuickBite/core/network/api_exceptions.dart';
import 'package:QuickBite/features/auth/data/auth_repo.dart';
import 'package:QuickBite/features/auth/data/user_model.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/checkout/data/order_model.dart';
import 'package:QuickBite/features/checkout/data/order_repo.dart';
import 'package:QuickBite/shared/custom_dialog.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../widgets/order_details_widget.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });
  final List<CartItemModel> cartItems;
  final String totalPrice;
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final OrderRepo _orderRepo = OrderRepo();

  final AuthRepo _authRepo = AuthRepo();
  UserModel? userModel;
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

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 140,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'Checkout',
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                  const Gap(6),
                  CustomText(
                    text: 'Review your order before payment',
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ],
              ),
              Gap(20),

              /// Order Details
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: OrderDetailsWidget(
                  order: widget.totalPrice,
                  taxes: '\$2',
                  fees: '\$3',
                  total:
                      (double.parse(widget.totalPrice) + 2 + 3)
                          .toString(),
                ),
              ),
              Gap(60),
              CustomText(
                text: 'Payment methods',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              Gap(20),
              userModel?.visa == null
                  ? SizedBox.shrink()
                  : PaymentMethodView(visaText: userModel!.visa),

              /// Check Box
              Row(
                children: [
                  Checkbox(
                    activeColor: AppColors.primary,
                    value: true,
                    onChanged: (value) {},
                  ),
                  Expanded(
                    child: CustomText(
                      text:
                          'Save card details for future payments',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      /// bottom Sheet
      bottomSheet: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientsPrimary,
          ),
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),

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
                  color: Colors.white70,
                  fontSize: 14,
                ),
                CustomText(
                  text:
                      '\$${(double.parse(widget.totalPrice) + 5).toStringAsFixed(2)}',
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            /// Checkout Button
            CustomButton(
              color: Colors.white,
              width: 150,
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
  const PaymentMethodView({super.key, this.visaText});

  final String? visaText;

  @override
  State<PaymentMethodView> createState() =>
      _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  int selectedValue = 1;

  Widget paymentCard({
    required int value,
    required String title,
    String? subtitle,
    required String image,
  }) {
    final isSelected = selectedValue == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValue = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Image.asset(image),
            ),

            const Gap(16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        paymentCard(
          value: 1,
          title: 'Cash on Delivery',
          image: 'assets/cash.png',
        ),

        const Gap(16),

        paymentCard(
          value: 2,
          title: 'Visa',
          image: 'assets/visa.png',
        ),
      ],
    );
  }
}
