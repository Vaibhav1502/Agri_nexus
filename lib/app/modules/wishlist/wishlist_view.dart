import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wishlist_controller.dart';

class WishlistView extends StatelessWidget {
  final controller = Get.put(WishlistController());

  WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchWishlist();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist ❤️"),
        centerTitle: true,
       // backgroundColor: Colors.green,
        actions: [
          Obx(() => controller.wishlistItems.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                  tooltip: "Clear Wishlist",
                  onPressed: () {
                    controller.clearWishlist();
                  },
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return const Center(child: Text("Your wishlist is empty 💔"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.wishlistItems.length,
          itemBuilder: (context, index) {
            final item = controller.wishlistItems[index];
             final int productId = item['id'];
            return GestureDetector(
              onTap: () {
                // Navigate to the product detail page, passing the product's ID
                Get.toNamed('/product-detail', arguments: productId);
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['image'] ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(item['name']),
                  subtitle: Text(
                    "₹${item['sale_price']} • ${item['discount_percentage']}% off",
                    style: const TextStyle(color: Colors.green),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.removeFromWishlist(item['id']);
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
