import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry/features/home/data/model/product_model.dart';
import 'package:hungry/features/home/data/repo/product_repo.dart';
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

  /// Get Products
  Future<void> getProducts() async {
    try {
      final res = await _productRepo.getProduct();
      setState(() {
        products = res;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: products == null,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                      UserHeader(),
                      Gap(20),
                      SearchField(),
                    ],
                  ),
                ),
              ),

              ///  Search + Categories
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
                padding: EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    childCount: products?.length ?? 6,
                    (context, index) {
                      ProductModel? product = products?[index];
                      return product == null
                          ? CupertinoActivityIndicator()
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsView(
                                          productId: product.id,
                                          productImage:
                                              product.image,
                                        ),
                                  ),
                                );
                              },
                              child: CardItem(
                                // rate: '4.9',
                                // desc: 'Wend\'s Burger',
                                // text: 'Cheeseburger',
                                // image: 'assets/burger.png',
                                rate: product.rate,
                                desc: product.desc,
                                text: product.name,
                                image: product.image,
                              ),
                            );
                    },
                  ),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: .71,
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
