import 'package:flutter/material.dart';
import 'package:hungry/features/cart/data/cart_model.dart';

class CartHeader extends StatelessWidget {
  const CartHeader({super.key, required this.cartResponse});

  final GetCartResponse? cartResponse;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Cart",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "${cartResponse?.cartData.items.length ?? 0} item${(cartResponse?.cartData.items.length ?? 0) > 1 ? "s" : ""}",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
      ],
    );
  }
}
