import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/shared/custom_bottom_sheet.dart';
import 'package:hungry/shared/custom_snack.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/cart_item.dart';
import '../../checkout/view/checkout_view.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

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

  /// Get Cart Items
  Future<void> getCartItems() async {
    setState(() {
      isLoading = true;
    });
    final response = await _cartRepo.getCartItems();
    final itemCount = response.cartData.items.length;
    setState(() {
      isLoading = false;
      cartResponse = response;
      quantities = List.generate(itemCount, (_) => 1);
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
              child: CustomText(
                text: 'No items in cart',
                color: Colors.black,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [
                  const Gap(60),

                  /// Title
                  Row(
                    children: const [
                      CustomText(
                        text: "My Cart",
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),

                  /// Cart Items List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 10),
                      itemCount:
                          cartResponse?.cartData.items.length ??
                          0,
                      separatorBuilder: (_, __) => const Gap(15),
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
                            setState() {}
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
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      CustomText(
                        text: cartResponse!.cartData.totalPrice
                            .toString(),
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),

                  /// Checkout Button
                  CustomButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    text: 'Checkout',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CheckoutView(
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
