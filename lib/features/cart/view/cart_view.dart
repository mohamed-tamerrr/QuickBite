import 'package:QuickBite/features/cart/cubit/cart_cubit.dart';
import 'package:QuickBite/features/cart/widgets/cart_header.dart';
import 'package:QuickBite/features/cart/widgets/cart_item.dart';
import 'package:QuickBite/features/orders/views/checkout_view.dart';
import 'package:QuickBite/shared/custom_bottom_sheet.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is RemoveCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(
              msg: 'Item removed from cart',
              color: Colors.green,
            ),
          );
        }
        if (state is RemoveCartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(
              msg: "Failed To Remove",
              color: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.watch<CartCubit>();
        if (state is GetCartLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body:
              cubit.cartResponse?.cartData.items.isEmpty ?? true
              ? Center(
                  /// No Items
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 90,
                        color: Colors.grey.shade400,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Add something delicious 🍔',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    children: [
                      const Gap(60),

                      /// Cart Header
                      CartHeader(
                        cartResponse: cubit.cartResponse,
                      ),

                      /// Cart Items List
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          itemCount:
                              cubit
                                  .cartResponse
                                  ?.cartData
                                  .items
                                  .length ??
                              0,
                          separatorBuilder: (_, _) =>
                              const Gap(18),
                          itemBuilder: (context, index) {
                            final item = cubit
                                .cartResponse
                                ?.cartData
                                .items[index];
                            return CartItem(
                              isLoading:
                                  cubit.deletingItemId ==
                                  item?.itemId,
                              text: item?.productName ?? '',
                              desc:
                                  'Spicy : ${item?.spicyLevel ?? ''}',
                              image: item?.productImage ?? '',
                              onAdd: () => cubit.onAdd(index),
                              onMinus: () =>
                                  cubit.onMinus(index),
                              onRemove: () =>
                                  cubit.removeCartItem(
                                    item?.itemId ?? 0,
                                  ),
                              quantity: cubit.quantities[index],
                            );
                          },
                        ),
                      ),

                      /// space so last item not hidden behind bottom sheet
                      const Gap(130),
                    ],
                  ),
                ),

          /// Bottom Sheet
          bottomSheet:
              cubit.cartResponse?.cartData.items.isEmpty ?? true
              ? SizedBox.shrink()
              : CustomBottomSheet(
                  body: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      /// Total Section
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const CustomText(
                            text: 'Total',
                            color: Colors.white70,
                            fontSize: 14,
                          ),

                          CustomText(
                            text:
                                '\$${cubit.cartResponse!.cartData.totalPrice}',
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),

                      /// Checkout Button
                      CustomButton(
                        width: 140,
                        color: Colors.white,
                        textColor: Colors.black,
                        text: 'Checkout',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CheckoutView(
                                totalPrice: cubit
                                    .cartResponse!
                                    .cartData
                                    .totalPrice,
                                cartItems: cubit
                                    .cartResponse!
                                    .cartData
                                    .items,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
