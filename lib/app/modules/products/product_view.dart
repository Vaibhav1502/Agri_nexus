import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_controller.dart';

class ProductView extends StatelessWidget {
  final controller = Get.put(ProductController());
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('All Products'),
        centerTitle: true,
        //backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search  products...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    // 👇 Reload all products when search is cleared
                    controller.fetchAllProducts(); 
                  },
                ),
              ),
              
              onChanged: (value) {
                // Optional: Search as you type, or keep onSubmitted
                if (value.isEmpty) {
                  controller.fetchAllProducts();
                }
              },
        
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.searchProducts(value);
                }else {
                  controller.fetchAllProducts();
                }
              },

              
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.products.isEmpty) {
                  return const Center(
                    child: Text('No products found', style: TextStyle(fontSize: 16)),
                  );
                }
                return GridView.builder(
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (context, index) {
                    final product = controller.products[index];
                     return GestureDetector(
                      onTap: () {
                        Get.toNamed('/product-detail', arguments: product.id);
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Image Section (Expanded to take top space)
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  product.image ?? '',
                                  width: double.infinity,
                                  fit: BoxFit.cover, // Fills the box nicely
                                  errorBuilder: (c, o, s) => Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            
                            // 2. Text Details Section (Bottom part)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Description
                                  Text(
                                    product.description ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Price
                                  Text(
                                    product.price != null
                                        ? '₹${product.price!.toStringAsFixed(2)}'
                                        : 'N/A',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }
}