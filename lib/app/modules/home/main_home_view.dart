import 'package:agri_nexus_ht/app/modules/cart/cart_view.dart';
import 'package:agri_nexus_ht/app/modules/orders/order_view.dart';
import 'package:agri_nexus_ht/app/modules/products/product_view.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_view.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cart/cart_controller.dart';
import 'home_controller.dart';
import 'home_view.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final cartController = Get.find<CartController>();
    //  final profileController = Get.put(ProfileController(), permanent: true);
    // final wishlistController = Get.put(WishlistController(), permanent: true);
    cartController.fetchCartCount();

    final List<Widget> pages = [
      HomeView(),
      ProductView(),
      WishlistView(),
      CartView(),
      OrderView(),
      ProfileView(),
      
      const Center(
        child: Text(
          "Profile (Coming Soon)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ];

    return Obx(() {
      return Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          //selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search, ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
  icon: Icon(Icons.favorite_border),
  activeIcon: Icon(Icons.favorite, color: Colors.red),
  label: 'Wishlist',
),

            // 🛒 Cart with badge
            BottomNavigationBarItem(
              icon: Obx(() {
                final count = cartController.cartCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_cart),
                    if (count > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              label: 'Cart',
            ),
             
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long, color: Colors.green),
              label: 'Orders',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
