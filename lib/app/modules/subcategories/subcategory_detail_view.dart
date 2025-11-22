// category_detail_view.dart

import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:agri_nexus_ht/app/modules/home/widgets/add_to_cart_button.dart';
import 'package:agri_nexus_ht/app/modules/subcategories/subcategory_detail_controller.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SubcategoryDetailView  extends StatelessWidget {
  // Find the existing permanent controllers
  
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();

  SubcategoryDetailView ({super.key});

  @override
  Widget build(BuildContext context) {
     final SubcategoryDetailController controller = Get.put(SubcategoryDetailController());
    final String subcategorySlug = Get.arguments as String;// category ID passed from HomeView
    return GetBuilder<SubcategoryDetailController>(
      initState: (_) {
        // This is called once when the widget is first inserted into the tree.
       controller.fetchSubcategoryDetails(subcategorySlug);
      },
      builder: (ctrl) {
        // Find the other permanent controllers
        final cartController = Get.find<CartController>();
        final wishlistController = Get.find<WishlistController>();


    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.subcategoryName.value.isNotEmpty
            ? controller.subcategoryName.value
            : "Category Details")),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Category Header ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.subcategoryName.value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (controller.subcategoryDescription.value.isNotEmpty)
                      Text(
                        controller.subcategoryDescription.value,
                        style: const TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              const Divider(height: 30),

              // --- Products Section Title ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "Products",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              // --- Products Grid ---
              Obx(() {
                if (controller.products.isEmpty) {
                  return const Center(
                    heightFactor: 5, // Give it some vertical space
                    child: Text("No products found in this category."),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65, // Adjusted for buttons
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                    
                    // 👇 --- THIS IS THE MAIN FIX --- 👇
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the product detail page with the product's ID
                        Get.toNamed('/product-detail', arguments: product.id);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // --- Product Image ---
                                Expanded(
                                  child: Image.network(
                                    product.image ?? '',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                // --- Product Info and Actions ---
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 2, // Allow for longer names
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Use the smart getter for price
                                      Text(
                                        "₹${product.displayPrice.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // --- Add to Cart Button ---
                                      AddToCartButton(
  productId: product.id,
  cartController: cartController,
),
                                      // SizedBox(
                                      //   width: double.infinity,
                                      //   child: ElevatedButton(
                                      //     onPressed: () {
                                      //       cartController.addToCart(product.id);
                                      //     },
                                      //     style: ElevatedButton.styleFrom(
                                      //       padding: const EdgeInsets.symmetric(vertical: 8),
                                      //     ),
                                      //     child: const Text("Add to Cart"),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // --- Wishlist Icon ---
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Obx(() {
                                bool isInWishlist = wishlistController.wishlistItems
                                    .any((item) => item['id'] == product.id);
                                return CircleAvatar(
                                  backgroundColor: Colors.black.withOpacity(0.3),
                                  radius: 18,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                                      color: Colors.red.shade400,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      if (isInWishlist) {
                                        wishlistController.removeFromWishlist(product.id);
                                      } else {
                                        wishlistController.addToWishlist(product.id);
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  });
}
}