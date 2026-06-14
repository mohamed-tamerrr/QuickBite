import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/home/data/model/topping_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/product/widgets/custom_button_product_details.dart';
import 'package:hungry/shared/custom_bottom_sheet.dart';
import 'package:hungry/shared/custom_snack.dart';
import '../widgets/spicy_slider.dart';
import '../widgets/topping_card.dart';
import '../../../shared/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    super.key,
    required this.productId,
    required this.productImage,
    required this.productPrice,
  });
  final int productId;
  final String productImage;
  final String productPrice;
  @override
  State<ProductDetailsView> createState() =>
      _ProductDetailsViewState();
}

class _ProductDetailsViewState
    extends State<ProductDetailsView> {
  double value = 0.5;
  final ProductRepo _productRepo = ProductRepo();
  List<ToppingModel>? options;
  List<ToppingModel>? toppings;

  Set<int> selectedToppings = {};
  Set<int> selectedOptions = {};

  bool isLoading = false;

  /// Get Toppings
  Future<void> _getToppings() async {
    final res = await _productRepo.getToppings();
    // if (!mounted) return;
    setState(() {
      toppings = res;
    });
  }

  /// Get Options
  Future<void> _getOptions() async {
    final res = await _productRepo.getOptions();
    // if (!mounted) return;
    setState(() {
      options = res;
    });
  }

  final CartRepo _cartRepo = CartRepo();

  void onAddToCart() async {
    setState(() {
      isLoading = true;
    });
    try {
      final cart = CartModel(
        productId: widget.productId,
        qty: 1,
        spicy: value,
        toppings: selectedToppings.toList(),
        options: selectedOptions.toList(),
      );
      await _cartRepo.addToCart(CartRequestModel(items: [cart]));
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(msg: 'Success', color: Colors.green),
      );
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        customSnack(msg: 'Failed', color: Colors.red),
      );
      throw e.toString();
    }
  }

  @override
  void initState() {
    _getToppings();
    _getOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Product Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Product Image
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Hero(
                      tag: widget.productImage,
                      child: Image.network(
                        widget.productImage,
                        width: 280,
                        height: 280,
                        fit: BoxFit.contain,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppColors.gradientsPrimary,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomText(
                        text: widget.productPrice,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(20),

              /// Spice Level Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .06),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Spice Level 🌶️',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),

                    const Gap(15),

                    SpicySlider(
                      value: value,
                      onChanged: (v) {
                        setState(() {
                          value = v;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const Gap(30),

              const CustomText(
                text: 'Toppings',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),

              const Gap(15),

              /// Toppings
              SizedBox(
                height: 150,
                child: toppings == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: toppings!.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final topping = toppings![index];

                          final isSelected = selectedToppings
                              .contains(topping.id);

                          return ExtraCard(
                            image: topping.image,
                            name: topping.name,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedToppings.remove(
                                    topping.id,
                                  );
                                } else {
                                  selectedToppings.add(
                                    topping.id,
                                  );
                                }
                              });
                            },
                          );
                        },
                      ),
              ),

              const Gap(30),

              const CustomText(
                text: 'Side Options',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),

              const Gap(15),

              /// Side Options
              SizedBox(
                height: 150,
                child: options == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: options!.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final option = options![index];

                          final isSelected = selectedOptions
                              .contains(option.id);

                          return ExtraCard(
                            image: option.image,
                            name: option.name,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedOptions.remove(
                                    option.id,
                                  );
                                } else {
                                  selectedOptions.add(option.id);
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: CustomBottomSheet(
        isLoading: isLoading,
        onTap: onAddToCart,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Total',
                  fontSize: 20,
                  color: Colors.white,
                ),
                CustomText(
                  text: widget.productPrice,
                  fontSize: 30,
                  color: Colors.white,
                ),
              ],
            ),
            CustomProductDetailsButton(
              color: Colors.white,
              isLoading: isLoading,
              text: 'Add To Cart',
              textColor: Colors.black,
              iconColor: Colors.black,
              onTap: onAddToCart,
            ),
          ],
        ),
      ),
    );
  }
}
