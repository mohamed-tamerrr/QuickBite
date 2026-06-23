import 'package:QuickBite/features/auth/cubit/auth_cubit.dart';
import 'package:QuickBite/features/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'product_details_view.dart';
import '../widgets/card_item.dart';
import '../widgets/food_category.dart';
import '../widgets/search_field.dart';
import '../widgets/user_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<AuthCubit>().getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final homeCubit = context.read<HomeCubit>();
        final authCubit = context.read<AuthCubit>();
        return Skeletonizer(
          enabled: state is HomeLoading,
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
                                authCubit.currentUser?.image
                                    .toString() ??
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvts5aHBstDkR8PigS4RmZkbZy78zpZoSuOw&s",
                            name:
                                authCubit.currentUser?.name ??
                                'ttttamer',
                          ),

                          SearchField(
                            controller:
                                homeCubit.searchController,
                            onChanged: homeCubit.searchProducts,
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
                          selectedIndex: homeCubit.selectedIndex,
                          categories: homeCubit.categories,
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
                        childCount: state is HomeLoading
                            ? 6
                            : homeCubit.products?.length ?? 0,
                        (context, index) {
                          /// SHIMMER
                          if (state is HomeLoading) {
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
                                      padding: EdgeInsets.all(
                                        10,
                                      ),
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
                                          padding:
                                              EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black12,
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

                          final product =
                              homeCubit.products![index];

                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) =>
                                    ProductDetailsView(
                                      productImage:
                                          product.image,
                                      productId: product.id,
                                      productPrice:
                                          product.price,
                                    ),
                              ),
                            ),
                            child: CardItem(
                              id: product.id,
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
      },
    );
  }
}
