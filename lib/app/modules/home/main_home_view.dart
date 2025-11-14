import 'package:agri_nexus_ht/app/controller/global_controller.dart';
import 'package:agri_nexus_ht/app/modules/cart/cart_view.dart';
import 'package:agri_nexus_ht/app/modules/orders/order_view.dart';
import 'package:agri_nexus_ht/app/modules/products/product_view.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_view.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cart/cart_controller.dart';
import 'home_controller.dart';
import 'home_view.dart';

class MainHomeView extends StatelessWidget {
  const MainHomeView({super.key});

  // 👇 --- ADD THE URL LAUNCHER LOGIC HERE --- 👇
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Could not open the link.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final cartController = Get.find<CartController>();
    final globalController = Get.find<GlobalController>();
    //  final profileController = Get.put(ProfileController(), permanent: true);
    // final wishlistController = Get.put(WishlistController(), permanent: true);
    //cartController.fetchCartCount();

    final List<Widget> pages = [
      HomeView(),
      ProductView(),
      WishlistView(),
      CartView(),
      OrderView(),
      ProfileView(),
    ];

    return Obx((){
      return  PopScope(
        // The `canPop` property determines if the screen can be popped.
        // We set it to `false` to always intercept the back press.
        canPop: controller.selectedIndex.value == 0,
      
        // The `onPopInvoked` callback is where our logic runs.
        // The `didPop` boolean tells us if the pop was successful (we can ignore it here).
        onPopInvoked: ( didPop) {
          // We call our controller's logic. If it returns `true`, it means we
          // should exit, so we manually pop the navigator.
          if (didPop) {
            // This will close the app.
            return;
          }
      
           print("Back button pressed on a non-home tab. Switching to Home.");
          controller.changeTab(0);
        },
      
        child: Obx(() {
          return Scaffold(
            floatingActionButton: SpeedDial(
              icon: Icons.share, // The icon for the main button
              activeIcon: Icons.close, // The icon when the menu is open
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              spacing: 12,
              spaceBetweenChildren: 8,
              children: [
                _buildSpeedDialChild(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onTap: () => _launchURL("https://wa.me/+918295282656"),
                ),
                _buildSpeedDialChild(
                  icon: FontAwesomeIcons.instagram,
                  label: 'Instagram',
                  color: Colors.purple,
                  onTap: () => _launchURL(
                    "https://www.instagram.com/greekekart?igsh=YW1kcWRubmNrYXNm",
                  ),
                ),
                _buildSpeedDialChild(
                  icon: FontAwesomeIcons.youtube,
                  label: 'YouTube',
                  color: Colors.red,
                  onTap: () => _launchURL(
                    "https://youtube.com/@greenekart2626?si=PM9kj_cYg8Y08l6T",
                  ),
                ),
                _buildSpeedDialChild(
                  icon: FontAwesomeIcons.facebook,
                  label: 'Facebook',
                  color: Colors.blue,
                  onTap: () => _launchURL("https://www.facebook.com/greenekart"),
                ),
              ],
            ),
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
                  activeIcon: Icon(Icons.search),
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
                    final count = cartController.cartCount;
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
          
        }),
      );
    });
    
  }
  SpeedDialChild _buildSpeedDialChild({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SpeedDialChild(
      child: FaIcon(icon, color: Colors.white),
      label: label,
      backgroundColor: color,
      onTap: onTap,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
      labelBackgroundColor: color,
    );
  }
  
}
