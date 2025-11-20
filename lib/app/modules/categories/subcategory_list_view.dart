// app/modules/categories/subcategory_list_view.dart

import 'package:agri_nexus_ht/app/data/models/category_model.dart';
import 'package:agri_nexus_ht/app/data/models/subcategory_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubcategoryListView extends StatelessWidget {
  const SubcategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the parent Category object passed from the previous screen
    final Category parentCategory = Get.arguments as Category;

    return Scaffold(
      appBar: AppBar(
        title: Text(parentCategory.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: parentCategory.subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = parentCategory.subcategories[index];
          return _buildSubcategoryCard(subcategory);
        },
      ),
    );
  }

  // Helper widget for building a single subcategory card
  Widget _buildSubcategoryCard(Subcategory subcategory) {
    return GestureDetector(
      onTap: () {
        // Navigate to the subcategory detail page with the products
        if (subcategory.slug != null && subcategory.slug!.isNotEmpty) {
          Get.toNamed('/subcategory-detail', arguments: subcategory.slug);
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
                Icons.label_important_outline, // Placeholder icon
                size: 35,
                color: Get.theme.primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                subcategory.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}