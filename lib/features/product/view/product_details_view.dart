import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  final toppings = [
    Topping(name: "Tomato", image: "assets/tomato.png"),
    Topping(name: "Onions", image: "assets/tomato.png"),
    Topping(name: "Pickles", image: "assets/tomato.png"),
    Topping(name: "Bacons", image: "assets/tomato.png"),
  ];
  double value = 0.5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: toppings.length,
                  itemBuilder: (context, index) {
                    return ToppingCard(
                      image: toppings[index].image,
                      name: toppings[index].name,
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: toppings.length,
                  itemBuilder: (context, index) {
                    return ToppingCard(
                      image: toppings[index].image,
                      name: toppings[index].name,
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
