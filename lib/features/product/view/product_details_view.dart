import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/features/cart/data/cart_model.dart';
import 'package:hungry/features/cart/data/cart_repo.dart';
import 'package:hungry/features/home/data/model/topping_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/features/product/widgets/custom_button_product_details.dart';
import 'package:hungry/shared/custom_snack.dart';
import '../widgets/spicy_slider.dart';
import '../widgets/topping_card.dart';
import '../../../shared/custom_button.dart';
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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.transparent,
                    child: Image.network(
                      widget.productImage,
                      width: 200,
                    ),
                  ),
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
              const Gap(50),
              const CustomText(text: 'Toppings', fontSize: 20),
              const Gap(10),
              SizedBox(
                height: 150,

                /// Toppings
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: toppings?.length,
                  itemBuilder: (context, index) {
                    final topping = toppings?[index];
                    final id = topping?.id;
                    final isSelected = selectedToppings.contains(
                      id,
                    );
                    return topping == null
                        ? CupertinoActivityIndicator()
                        : ExtraCard(
                            onTap: () {
                              setState(() {
                                if (selectedToppings.contains(
                                  id,
                                )) {
                                  selectedToppings.remove(id);
                                } else {
                                  selectedToppings.add(id!);
                                }
                              });
                            },
                            image: topping.image,
                            name: topping.name,
                            isSelected: isSelected,
                          );
                  },
                ),
              ),

              const Gap(50),
              const CustomText(
                text: 'Side options',
                fontSize: 20,
              ),
              const Gap(10),
              SizedBox(
                height: 150,

                // Options
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: options?.length,
                  itemBuilder: (context, index) {
                    final option = options?[index];
                    final id = option?.id;
                    final isSelected = selectedOptions.contains(
                      id,
                    );
                    return option == null
                        ? CupertinoActivityIndicator()
                        : ExtraCard(
                            onTap: () {
                              setState(() {
                                if (selectedOptions.contains(
                                  id,
                                )) {
                                  selectedOptions.remove(id);
                                } else {
                                  selectedOptions.add(id!);
                                }
                              });
                            },
                            image: option.image,
                            name: option.name,
                            isSelected: isSelected,
                          );
                  },
                ),
              ),
              Gap(500),
            ],
          ),
        ),
      ),

      bottomSheet: Container(
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.card,
          gradient: LinearGradient(
            colors: AppColors.gradientsPrimary,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(
                alpha: 0.08,
              ),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        child: Row(
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

              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  final cart = CartModel(
                    productId: widget.productId,
                    qty: 1,
                    spicy: value,
                    toppings: [],
                    options: [],
                  );
                  await _cartRepo.addToCart(
                    CartRequestModel(items: [cart]),
                  );
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnack(
                      msg: 'Success',
                      color: Colors.green,
                    ),
                  );
                } on Exception catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    customSnack(
                      msg: 'Failed',
                      color: Colors.red,
                    ),
                  );
                  throw e.toString();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
