import 'package:QuickBite/core/constants/app_colors.dart';
import 'package:QuickBite/features/cart/cubit/cart_cubit.dart';
import 'package:QuickBite/features/cart/data/cart_model.dart';
import 'package:QuickBite/features/home/cubit/home_cubit.dart';
import 'package:QuickBite/features/home/widgets/custom_button_product_details.dart';
import 'package:QuickBite/shared/custom_bottom_sheet.dart';
import 'package:QuickBite/shared/custom_snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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

  @override
  void initState() {
    final cubit = context.read<HomeCubit>();
    cubit.getOptions();
    cubit.getToppings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is AddCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(
              msg: 'Added To Cart Successfully',
              color: Colors.green,
            ),
          );
        }

        if (state is AddCartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(msg: 'Failed', color: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
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
                          tag: widget.productId,
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
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
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
                          color: Colors.black.withValues(
                            alpha: .06,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                    child: state is HomeLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.toppings!.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final topping =
                                  cubit.toppings![index];

                              final isSelected = cubit
                                  .selectedToppings
                                  .contains(topping.id);

                              return ExtraCard(
                                image: topping.image,
                                name: topping.name,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      cubit.selectedToppings
                                          .remove(topping.id);
                                    } else {
                                      cubit.selectedToppings.add(
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
                    child: state is HomeLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.options!.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final option =
                                  cubit.products![index];

                              final isSelected = cubit
                                  .selectedOptions
                                  .contains(option.id);

                              return ExtraCard(
                                image: option.image,
                                name: option.name,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      cubit.selectedOptions
                                          .remove(option.id);
                                    } else {
                                      cubit.selectedOptions.add(
                                        option.id,
                                      );
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
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
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
                  isLoading: state is AddCartLoading,
                  text: 'Add To Cart',
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  onTap: () async {
                    cubit.addToCart(
                      CartRequestModel(
                        items: [
                          CartModel(
                            productId: widget.productId,
                            qty: 1,
                            spicy: value,
                            toppings: [],
                            options: [],
                          ),
                        ],
                      ),
                    );
                    await context
                        .read<CartCubit>()
                        .getCartItems();
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
