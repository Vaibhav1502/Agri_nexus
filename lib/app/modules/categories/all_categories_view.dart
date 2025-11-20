// app/modules/categories/all_categories_view.dart

import 'package:agri_nexus_ht/app/data/models/category_model.dart';
import 'package:agri_nexus_ht/app/modules/home/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Categories"),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories found."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchCategories(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cards per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0, // Makes the cards square
            ),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _buildCategoryCard(category);
            },
          ),
        );
      }),
    );
  }

  // Helper widget for building a single category card
  Widget _buildCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        // If the category has subcategories, navigate to the new subcategory list screen
        if (category.subcategories.isNotEmpty) {
          Get.toNamed('/subcategory-list', arguments: category);
        } 
        // Otherwise, navigate directly to the product detail page for that category
        else {
          if (category.slug != null && category.slug!.isNotEmpty) {
            Get.toNamed('/category-detail', arguments: category.slug);
          }
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.category_rounded, // Placeholder icon
                size: 35,
                color: Get.theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            // Show a small indicator if there are subcategories
            if (category.subcategories.isNotEmpty)
              const Icon(Icons.arrow_drop_down, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}