import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'core/constants/app_colors.dart';

import 'features/auth/view/profile_view.dart';

import 'features/cart/view/cart_view.dart';
import 'features/home/view/home_view.dart';
import 'features/orderHistory/view/order_history_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late List<Widget> screens;
  late PageController controller;
  int currentScreen = 0;
  @override
  void initState() {
    screens = [
      HomeView(),
      CartView(),
      OrderHistoryView(),
      ProfileView(),
    ];
    controller = PageController(initialPage: currentScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: screens,
      ),

      bottomNavigationBar: SalomonBottomBar(
        backgroundColor: Colors.transparent,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),

        margin: EdgeInsets.all(30),
        currentIndex: currentScreen,
        onTap: (index) {
          setState(() {
            currentScreen = index;

            controller.jumpToPage(currentScreen);
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("Cart"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.history),
            title: Text("Orders"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
      //  Container(
      //   margin: EdgeInsets.all(10),
      //   padding: EdgeInsets.all(10),
      //   decoration: BoxDecoration(
      //     color: AppColors.primary,
      //     borderRadius: BorderRadius.circular(30),
      //   ),
      //   child: BottomNavigationBar(
      //     elevation: 0,
      //     backgroundColor: Colors.transparent,
      //     type: BottomNavigationBarType.fixed,
      //     selectedItemColor: Colors.white,
      //     unselectedItemColor: AppColors.textSecondary,
      //     currentIndex: currentScreen,
      //     onTap: (index) {
      //       setState(() {
      //         currentScreen = index;
      //         controller.jumpToPage(currentScreen);
      //       });
      //     },

      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: "Home",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.shopping_cart),
      //         label: "Cart",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.history),
      //         label: "Orders",
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: "Profile",
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
