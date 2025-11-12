// product_detail_view.dart

import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'product_detail_controller.dart';

class ProductDetailView extends StatelessWidget {
  final int productId;
  ProductDetailView({required this.productId, super.key});

  // It's better to find existing controllers than to create new ones here
  final controller = Get.put(ProductDetailController());
  final cartController = Get.find<CartController>();
  final wishlistController = Get.find<WishlistController>();

  void _onShare(BuildContext context, String productName, int productId) {
    // In a real app, you would create a dynamic link or a URL to your product page.
    // For now, we'll just share the product name and a placeholder link.
    final String productUrl = "https://nexus.heuristictechpark.com//products/$productId";
    final String shareText = "Check out this amazing product: $productName!\n\n$productUrl";

    Share.share(shareText, subject: 'Look what I found!');
  }

  @override
  Widget build(BuildContext context) {
    // Load the product data when the widget is built
    controller.loadProduct(productId);

    return Scaffold(
      // Use a floating action button for the main action
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        final product = controller.product.value;
        if (product == null || controller.isLoading.value) {
          return const SizedBox.shrink(); // Hide button while loading
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: FloatingActionButton.extended(
              onPressed: () {
                cartController.addToCart(product.id);
              },
              backgroundColor: Theme.of(context).primaryColor,
              icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
              label: const Text(
                "Add to Cart",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product.value;
        if (product == null) {
          return const Center(child: Text("Product not found"));
        }

        // Use a CustomScrollView for a more flexible layout with a collapsing app bar
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              floating: false,
              elevation: 2,
              backgroundColor: Theme.of(context).cardColor,
              leading: BackButton(color: Theme.of(context).primaryColor),
              actions: [
                Obx(() {
                  bool isInWishlist = wishlistController.wishlistItems
                      .any((item) => item['id'] == product.id);
                  return IconButton(
                    icon: Icon(
                      isInWishlist ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (isInWishlist) {
                        wishlistController.removeFromWishlist(product.id);
                      } else {
                        wishlistController.addToWishlist(product.id);
                      }
                    },
                  );
                }),
                // IconButton(
                //   icon: Icon(Icons.share, color: Theme.of(context).primaryColor),
                //   onPressed: () {
                //     // TODO: Implement share functionality
                //   },
                // ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product_image_${product.id}', // For smooth animations from product list
                  child: Image.network(
                    product.image ?? '',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100), // Padding at bottom for FAB
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Product Title and Brand ---
                    Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title (takes up available space)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Slug: ${product.slug ?? 'N/A'}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Brand: ${product.brand ?? 'N/A'}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Short Description: ${product.shortDescription ?? 'N/A'}",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                // Social Media Icons
                const SizedBox(width: 16),
                Row(
                  children: [
                    _buildSocialIcon(
                      Icons.share,
                      onTap: () => _onShare(context, product.name, product.id),
                    ),
                    const SizedBox(width: 8),
                    //    Image.network(product.images?[0]??'',
                    // width: 150,
                    // height: 150,
                    // fit: BoxFit.cover),
                   
                    // _buildSocialIcon(
                    //   Icons.wechat, // Placeholder for WhatsApp, as there's no direct icon
                    //   onTap: () => _onShare(context, product.name, product.id),
                    // ),
                  ],
                ),
              ],
            ),
                    const SizedBox(height: 20),

                    // --- Price Section ---
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "₹${product.displayPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Spacer(),
                            //const SizedBox(width: 16),
                            if (product.displayOriginalPrice > product.displayPrice)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${product.displayOriginalPrice.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "${product.discountPercentage}% OFF",
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 40, thickness: 1),

                    // --- Description and Details ---
                    _buildSectionTitle("Description"),
                    const SizedBox(height: 8),
                    Text(
                      product.description ?? 'No description available.',
                      style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade800),
                    ),
                    const SizedBox(height: 24),

                    // You can add more details here in a structured way
                    _buildDetailRow("Power Source:", product.power_source ?? 'N/A'),
                    _buildDetailRow("Category:", product.categoryName ?? 'N/A'),
                    _buildDetailRow("Model:", product.model ?? 'N/A'),
                    _buildDetailRow("Sku", product.sku ?? 'N/A'),
                    _buildDetailRow("Stock Quantity:", product.stock_quantity?.toString() ?? 'N/A'),
                    _buildDetailRow("warranty", product.warranty?.toString() ?? 'N/A'),
                    _buildDetailRow("Weight", product.weight?.toString()?? 'N/A'),
                    _buildDetailRow("Dimensions", product.dimensions?.toString()?? 'N/A'),
                    
                   
                    
                    const Divider(height: 40, thickness: 1),

                    // --- Related Products ---
                    _buildSectionTitle("Related Products"),
                    const SizedBox(height: 16),
                    if (product.relatedProducts.isNotEmpty)
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: product.relatedProducts.length,
                          itemBuilder: (context, index) {
                            final related = product.relatedProducts[index];
                            return _buildRelatedProductCard(related);
                          },
                        ),
                      )
                    else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text("No related products found."),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper widget for section titles for consistency
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }

  Widget _buildSocialIcon(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade200,
        child: Icon(
          icon,
          color: Colors.grey.shade700,
          size: 22,
        ),
      ),
    );
  }

  // Helper widget for key-value detail rows
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade900),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for building a single related product card
  Widget _buildRelatedProductCard(dynamic related) {
    return GestureDetector(
      onTap: () => Get.off(() => ProductDetailView(productId: related.id)), // Use Get.off to avoid building up a stack
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias, // Ensures the image respects the border radius
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  related.image ?? '',
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      related.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "₹${related.displayPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}