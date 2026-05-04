import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/widgets/cart_item.dart';
import 'package:hungry/shared/custom_button.dart';
import 'package:hungry/shared/custom_text.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final int itemCount = 20;
  late List<int> quantities;

  @override
  void initState() {
    quantities = List.generate(itemCount, (index) => 1);
    super.initState();
  }

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
                itemCount: itemCount,
                separatorBuilder: (_, __) => const Gap(15),
                itemBuilder: (context, index) {
                  return CartItem(
                    text: 'Pizza Margherita',
                    desc: 'Veggie Burger',
                    image: 'assets/cart.png',
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
                      setState(() {});
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
        height: 100,
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
            CustomButton(text: 'Checkout', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
