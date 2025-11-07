import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/modules/home/category_controller.dart';
import 'package:agri_nexus_ht/app/modules/home/featured_product_controller.dart';
import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:agri_nexus_ht/app/modules/home/widgets/pending_approval_banner.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:agri_nexus_ht/app/modules/product_detail/product_detail_view.dart';
import 'package:agri_nexus_ht/utils/url_launcher_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final controller = Get.put(HomeController());
  final featuredController = Get.put(FeaturedProductController(), permanent: true);
  final categoryController = Get.put(CategoryController());
  final cartController = Get.put(CartController());
  final wishlistController = Get.put(WishlistController());
  final TextEditingController searchController = TextEditingController();
  final authController = Get.find<AuthController>(); // Add this line

  final String facebookUrl = "https://www.facebook.com/your-page-name";
  final String instagramUrl = "https://www.instagram.com/your-profile-name";
  final String twitterUrl = "https://www.twitter.com/your-handle";

  HomeView({super.key});

  final List<String> bannerImages = [
    "https://img.freepik.com/free-vector/farm-template-design_23-2150178972.jpg?semt=ais_hybrid&w=740&q=80",
    "https://img.freepik.com/free-vector/hand-drawn-farming-lifestyle-webinar_23-2150205062.jpg?semt=ais_hybrid&w=740&q=80",
    "https://img.freepik.com/free-vector/hand-drawn-agriculture-company-template_23-2149682583.jpg?semt=ais_hybrid&w=740&q=80",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Green Leaf",style: TextStyle(fontSize: 30),),
        centerTitle: true,
        //backgroundColor: Colors.green,
        elevation: 0,
        actions: [
          _buildSocialIcon(
            'assets/images/facebook_icon.png', // Use custom icons for better branding
            onTap: () => UrlLauncherHelper.launch(facebookUrl),
          ),
          _buildSocialIcon(
            'assets/images/instagram_icon.png',
            onTap: () => UrlLauncherHelper.launch(instagramUrl),
          ),
          _buildSocialIcon(
            'assets/images/twitter_icon.png',
            onTap: () => UrlLauncherHelper.launch(twitterUrl),
          ),
          const SizedBox(width: 8), // Add some padding to the right edge
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<ProfileController>().fetchAndUpdateUserProfile();
          await controller.fetchProducts();
          await featuredController.fetchFeaturedProducts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // 👇 --- ADD THIS TEMPORARY DEBUG WIDGET --- 👇
                 Obx(() {
                  // Show the banner only if the user is a pending dealer.
                  if (authController.isPendingDealer) {
                    return const PendingApprovalBanner();
                  } else {
                    // Otherwise, show nothing.
                    return const SizedBox.shrink();
                  }
                }),
                // Obx(() => Container(
                //   width: double.infinity,
                //   color: Colors.amber.shade200,
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "DEBUG INFO:\n"
                //     "Is Logged In: ${authController.isLoggedIn}\n"
                //     "User Role: ${authController.currentUser.value?['role']}\n"
                //     "Is Approved: ${authController.currentUser.value?['is_dealer_approved']}\n"
                //     "FINAL VERDICT (isApprovedDealer): ${authController.isApprovedDealer}",
                //     style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                //   ),
                // )),
                // 👆 --- END OF DEBUG WIDGET --- 👆
                // 🖼️ Banner Carousel
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    ),
                    items: bannerImages.map((imageUrl) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                // 🧭 Category Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: const Text(
                    "Shop by Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Obx(() {
                  if (categoryController.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (categoryController.categories.isEmpty) {
                    return const Center(child: Text("No categories available"));
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryController.categories.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final category = categoryController.categories[index];
                        return GestureDetector(
                          onTap: () => Get.toNamed(
                            '/category-detail',
                            arguments: category.id,
                          ),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  //backgroundColor: Colors.green.shade100,
                                  child: Icon(
                                    Icons.agriculture,
                                    //color: Colors.green.shade700,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                // 🔍 Search Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      suffixIcon: Obx(
                        () => controller.isSearching.value
                            ? IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  searchController.clear();
                                  controller.clearSearch();
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 1.5),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        controller.searchProducts(query);
                      }
                    },
                  ),
                ),

                // 🌟 Featured Products Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: const Text(
                    "Featured Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Obx(() {
                  if (featuredController.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (featuredController.featuredProducts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No featured products available"),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredController.featuredProducts.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final product = featuredController.featuredProducts[index];
                        return GestureDetector(
                          onTap: () => Get.toNamed('/product-detail', arguments: product.id),
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: Container(
                                            color: Colors.white,
                                            child: Image.network(
                                              product.image ?? '',
                                              
                                              width: double.infinity,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) => Container(
                                                color: Colors.grey.shade200,
                                                child: const Icon(Icons.image_not_supported),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "₹${product.displayPrice.toStringAsFixed(2)}",
                                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${product.discountPercentage}% off",
                                              style: const TextStyle(color: Colors.red, fontSize: 12),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  cartController.addToCart(product.id, quantity: 1);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                 // backgroundColor: Colors.green,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                ),
                                                child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 14)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Obx(() {
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // 🛍️ All Products Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: const Text(
                    "All Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: Colors.green));
                    }

                    if (controller.products.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No products available"),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final product = controller.products[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/product-detail', arguments: product.id);
                          },
                          child: Card(
                            
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: Container(
                                          color: Colors.white,
                                          child: Image.network(
                                            product.image ?? '',
                                            
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(Icons.image_not_supported),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.categoryName ?? "",
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "₹${product.displayPrice.toStringAsFixed(2)}", // Use the new getter,
                                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "${product.discountPercentage}% off",
                                                style: const TextStyle(color: Colors.red, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                cartController.addToCart(product.id, quantity: 1);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                //backgroundColor: Colors.green,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                              ),
                                              child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 14)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Obx(() {
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
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSocialIcon(String imagePath, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.transparent, // Transparent background
          child: Image.asset(
            imagePath,
            width: 24, // Adjust size as needed
            height: 24,
            // Optional: Provide an error builder for the image
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.link, size: 20),
          ),
        ),
      ),
    );
  }
}
