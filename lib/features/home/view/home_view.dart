import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductDetailsView(),
                        ),
                      );
                    },
                    child: CardItem(
                      rate: '4.9',
                      desc: 'Wend\'s Burger',
                      text: 'Cheeseburger',
                      image: 'assets/burger.png',
                    ),
                  ),
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
    );
  }
}
