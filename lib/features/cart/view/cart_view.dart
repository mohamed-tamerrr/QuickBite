import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/cart/data/cart_repo.dart';
import 'package:QuickBite/features/cart/widgets/cart_header.dart';
import 'package:QuickBite/shared/custom_bottom_sheet.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';
import '../../orders/views/checkout_view.dart';
import '../widgets/cart_item.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late List<int> quantities = [];

  final CartRepo _cartRepo = CartRepo();
  GetCartResponse? cartResponse;
  bool isLoading = false;
  bool isLoadingItem = false;
  int? deletingItemId;
  int itemCount = 0;

  /// Get Cart Items
  Future<void> getCartItems() async {
    setState(() {
      isLoading = true;
    });
    final response = await _cartRepo.getCartItems();
    itemCount = response.cartData.items.length;
    setState(() {
      isLoading = false;
      cartResponse = response;
      // quantities = List.generate(itemCount, (_) => 1);
      quantities = response.cartData.items
          .map((e) => e.quantity)
          .toList();
    });
  }

  /// Delete Cart Item
  Future<void> removeCartItem(int id) async {
    try {
      if (!mounted) return;
      setState(() {
        deletingItemId = id;
      });
      await _cartRepo.removeCartItem(id);

      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(
          msg: 'Item removed from cart',
          color: Colors.green,
        ),
      );
      if (!mounted) return;
      getCartItems();
    } catch (e) {
      if (!mounted) return;
      print(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          deletingItemId = null;
        });
      }
    }
  }

  @override
  void initState() {
    getCartItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cartResponse?.cartData.items.isEmpty ?? true
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
                  CartHeader(cartResponse: cartResponse),

                  /// Cart Items List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: itemCount,
                      separatorBuilder: (_, _) => const Gap(18),
                      itemBuilder: (context, index) {
                        final item =
                            cartResponse?.cartData.items[index];
                        return CartItem(
                          isLoading:
                              deletingItemId == item?.itemId,
                          text: item?.productName ?? '',
                          desc:
                              'Spicy : ${item?.spicyLevel ?? ''}',
                          image: item?.productImage ?? '',
                          onAdd: () {
                            setState(() {
                              quantities[index]++;
                            });
                          },
                          onMinus: () {
                            setState(() {
                              if (quantities[index] > 1) {
                                quantities[index]--;
                              }
                            });
                          },
                          onRemove: () {
                            removeCartItem(item?.itemId ?? 0);
                          },
                          quantity: quantities[index],
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
      bottomSheet: cartResponse?.cartData.items.isEmpty ?? true
          ? SizedBox.shrink()
          : CustomBottomSheet(
              body: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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
                            '\$${cartResponse!.cartData.totalPrice}',
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
                            totalPrice: cartResponse!
                                .cartData
                                .totalPrice,
                            cartItems:
                                cartResponse!.cartData.items,
                          ),
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
