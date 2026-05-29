import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/home/data/model/topping_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';

import '../data/models/topping_model.dart';
import '../widgets/spicy_slider.dart';
import '../widgets/topping_card.dart';
import '../../../shared/custom_button.dart';
import '../../../shared/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

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
        backgroundColor: Colors.white,
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
              SpicySlider(
                value: value,
                onChanged: (v) {
                  setState(() {
                    value = v;
                  });
                },
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
                    return topping == null
                        ? CupertinoActivityIndicator()
                        : ToppingCard(
                            image: topping.image,
                            name: topping.name,
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

                /// Options
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: options?.length,
                  itemBuilder: (context, index) {
                    final option = options?[index];
                    return option == null
                        ? CupertinoActivityIndicator()
                        : ToppingCard(
                            image: option.image,
                            name: option.name,
                          );
                  },
                ),
              ),
              Gap(50),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'Total', fontSize: 20),
                      CustomText(text: '\$18.19', fontSize: 30),
                    ],
                  ),
                  CustomButton(
                    text: 'Add To Cart',
                    onTap: () {},
                  ),
                ],
              ),
              Gap(60),
            ],
          ),
        ),
      ),
    );
  }
}
