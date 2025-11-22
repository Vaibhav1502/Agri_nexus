// product_detail_view.dart

import 'package:agri_nexus_ht/app/data/models/offer_model.dart';
import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:agri_nexus_ht/app/modules/product_detail/widgets/full_screen_image_gallery.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'product_detail_controller.dart';

import 'package:agri_nexus_ht/api_config.dart';

class ProductDetailView extends StatelessWidget {
  final int productId;
  ProductDetailView({required this.productId, super.key});
 
   //final ProductDetailController controller = Get.find();
  // It's better to find existing controllers than to create new ones here
//  final controller = Get.put(ProductDetailController());
//   final cartController = Get.find<CartController>();
//   final wishlistController = Get.find<WishlistController>();

  void _onShare(BuildContext context, String productName, int productId) {
    // In a real app, you would create a dynamic link or a URL to your product page.
    // For now, we'll just share the product name and a placeholder link.

    //final String productUrl = "https://nexus.heuristictechpark.com//products/$productId";
    final String productUrl = "$baseUrl/products/$productId";
    final String shareText = "Check out this amazing product: $productName!\n\n$productUrl";

    Share.share(shareText, subject: 'Look what I found!');
  }

  @override
  Widget build(BuildContext context) {
       //Use the product ID as a unique tag
    
      final controller = Get.find<ProductDetailController>();
    // Find the other global controllers
    final cartController = Get.find<CartController>();
    final wishlistController = Get.find<WishlistController>();
     
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
                background: Obx(() {
                 final currentImage = controller.selectedImage.value;
    return GestureDetector(
      // 👇 --- ADD THIS ONTAP --- 👇
      onTap: () {
        // Create a list of all images (main + gallery)
        final product = controller.product.value!;
        final allImages = [product.image, ...product.images]
            .where((i) => i != null && i.isNotEmpty)
            .cast<String>()
            .toList();
            
        // Find the index of the currently displayed image
        final index = allImages.indexOf(currentImage);

        // Navigate to the full screen gallery
        Get.to(() => FullScreenImageGallery(
          images: allImages,
          initialIndex: index >= 0 ? index : 0,
        ));
      },
      
                child:AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Hero(
                        // Use the selectedImage as the key to trigger the animation
                        key: ValueKey<String>(controller.selectedImage.value),
                        tag: 'product_image_${product.id}',
                        child: Image.network(
                          controller.selectedImage.value, // Display the currently selected image
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
                          ),
                        ),
                      ),
                    ));
                }),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100), // Padding at bottom for FAB
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     if ((product.images).isNotEmpty)
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          // We include the main image in the thumbnail list for selection
                          itemCount: [product.image, ...product.images].where((img) => img != null).length,
                          itemBuilder: (context, index) {
                            // Create a combined list of the primary image and gallery images
                            final allImages = [product.image, ...product.images].whereType<String>().toList();
                            final imageUrl = allImages[index];
                            
                            return GestureDetector(
                              onTap: () => controller.changeImage(imageUrl),
                              child: Obx(() {
                                bool isSelected = controller.selectedImage.value == imageUrl;
                                return Container(
                                  width: 70,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                                      width: isSelected ? 2.5 : 1.0,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(Icons.hide_image_outlined),
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    if ((product.images).isNotEmpty)
                      const SizedBox(height: 20),
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
                     Obx(() {
          // Only show this section if there are offers for this product
          if (controller.productOffers.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 40, thickness: 1),
              _buildSectionTitle("Available Offers"),
              const SizedBox(height: 12),
              // Use a Column to list the offers vertically
              ...controller.productOffers.map((offer) => _buildOfferListItem(offer)).toList(),
            ],
          );
        }),
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

    Widget _buildOfferListItem(Offer offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_offer_outlined, color: Get.theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (offer.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    offer.description!,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
      onTap: () {
        final controller = Get.find<ProductDetailController>();
      controller.loadProduct(related.id);       // reload data
     Get.offNamed('/product-detail', arguments: related.id);
      }, // Use Get.off to avoid building up a stack
      
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