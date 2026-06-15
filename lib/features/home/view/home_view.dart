import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/features/auth/data/auth_repo.dart';
import 'package:hungry/features/auth/data/user_model.dart';
import 'package:hungry/features/home/data/model/product_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
import 'package:hungry/shared/custom_snack.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../widgets/card_item.dart';
import '../widgets/food_category.dart';
import '../widgets/search_field.dart';
import '../widgets/user_header.dart';
import '../../product/view/product_details_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List categories = ['All', 'Combos', 'Sliders', 'Classtic'];
  int selectedIndex = 0;

  final ProductRepo _productRepo = ProductRepo();
  List<ProductModel>? products;
  List<ProductModel>? allProducts;

  UserModel? userModel;
  final AuthRepo _authRepo = AuthRepo();

  /// Get Products
  Future<void> getProducts() async {
    try {
      final res = await _productRepo.getProduct();
      setState(() {
        products = res;
        allProducts = res;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  /// GetProfile
  Future<void> getProfileData() async {
    try {
      final user = await _authRepo.getProfileData();
      setState(() {
        userModel = user;
      });
    } catch (e) {
      String error = 'Error in profile';
      if (e is Failure) {
        error = e.errorMassage;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(customSnack(msg: error));
    }
  }

  final TextEditingController _searchController =
      TextEditingController();
  @override
  void initState() {
    getProfileData();
    getProducts();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: products == null,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              /// Header
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                scrolledUnderElevation: 0,
                toolbarHeight: 170,
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 38,
                  ),
                  child: Column(
                    children: [
                      UserHeader(
                        image:
                            userModel?.image.toString() ??
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvts5aHBstDkR8PigS4RmZkbZy78zpZoSuOw&s",
                        name: userModel?.name ?? 'ttttamer',
                      ),

                      SearchField(
                        controller: _searchController,
                        onChanged: (v) {
                          final query = v.toLowerCase();
                          setState(() {
                            products = allProducts
                                ?.where(
                                  (element) => element.name
                                      .toLowerCase()
                                      .contains(query),
                                )
                                .toList();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              ///   Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    child: FoodCategory(
                      selectedIndex: selectedIndex,
                      categories: categories,
                    ),
                  ),
                ),
              ),

              /// Food Items
              SliverPadding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 120,
                  top: 12,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: products?.length ?? 6,
                    (context, index) {
                      final reversedIndex =
                          (products?.length ?? 0) - 1 - index;
                      final product = products?[index];

                      /// SHIMMER
                      if (product == null) {
                        return Shimmer(
                          enabled: true,
                          direction: ShimmerDirection.rtl,
                          gradient: LinearGradient(
                            colors: [
                              Colors.black,
                              Colors.black38,
                              Colors.black87,
                            ],
                          ),
                          child: Container(
                            width: 250,
                            height: 140,
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 250,
                                  height: 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius:
                                        BorderRadius.circular(
                                          12,
                                        ),
                                  ),
                                ),
                                Gap(25),
                                Column(
                                  spacing: 10,
                                  children: List.generate(4, (
                                    index,
                                  ) {
                                    return Container(
                                      width: 250,
                                      height: 10,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(
                                              12,
                                            ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => ProductDetailsView(
                              productImage: product.image,
                              productId: product.id,
                              productPrice: product.price,
                            ),
                          ),
                        ),
                        child: CardItem(
                          text: product.name,
                          image: product.image,
                          desc: product.desc,
                          rate: product.rate,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
