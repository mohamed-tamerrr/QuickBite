import 'package:QuickBite/features/auth/cubit/auth_cubit.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/orders/cubit/orders_cubit.dart';
import 'package:QuickBite/features/orders/widgets/payment_method.dart';
import 'package:QuickBite/shared/custom_dialog.dart';
import 'package:QuickBite/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/custom_button.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().getProfileData();
  }

  Future<void> _onCheckoutPressed() async {
    final cubit = context.read<OrdersCubit>();
    await cubit.saveOrder(widget.cartItems);

    if (!mounted) return;

    if (cubit.state is OrdersCheckoutSuccess) {
      showDialog(
        context: context,
        builder: (context) {
          return const CustomDialog();
        },
      );
    }
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
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final cubit = context.read<AuthCubit>();
                  final userVisa = cubit.currentUser?.visa;

                  /// Loading
                  if (state is GetProfileLoading) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                            ),
                          ),
                          Gap(12),
                          CustomText(
                            text: 'Loading payment methods...',
                            fontSize: 14,
                          ),
                        ],
                      ),
                    );
                  }

                  return PaymentMethodView(
                    visaText: userVisa,
                    selectedMethod: cubit.selectedPaymentMethod,
                    onMethodSelected: cubit.setPaymentMethod,
                  );
                },
              ),

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
            BlocConsumer<OrdersCubit, OrdersState>(
              listener: (context, state) {
                if (state is OrdersFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errMsg)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is OrdersCheckoutLoading;
                return CustomButton(
                  color: Colors.white,
                  width: 150,
                  onTap: isLoading ? null : _onCheckoutPressed,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                          ),
                        )
                      : const CustomText(
                          text: 'Pay Now',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
