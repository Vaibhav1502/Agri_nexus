// app/modules/categories/all_categories_view.dart

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
          child: ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];

              // If a category has no subcategories, use a clean Card with a ListTile
              if (category.subcategories.isEmpty) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(
                        Icons.label_important_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      if (category.slug != null && category.slug!.isNotEmpty) {
                        Get.toNamed('/category-detail', arguments: category.slug);
                      }
                    },
                  ),
                );
              }

              // If it has subcategories, use a Card with an ExpansionTile
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias, // Ensures child widgets respect the card's shape
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.category_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Custom expansion icons for a cleaner look
                  trailing: const Icon(Icons.add),
                  onExpansionChanged: (isExpanded) {
                    // This is for animating the icon, but ExpansionTile handles it by default
                  },
                  children: [
                    // A container to give subcategories a distinct background and padding
                    Container(
                      color: Colors.grey.shade100,
                      child: Column(
                        children: category.subcategories.map((subcategory) {
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 32.0, right: 16.0),
                            title: Text(subcategory.name),
                            trailing: const Icon(Icons.chevron_right, size: 20),
                            onTap: () {
                              final slug = subcategory.slug;
                              if (slug != null && slug.isNotEmpty) {
                                Get.toNamed('/subcategory-detail', arguments: slug);
                              } else {
                                Get.snackbar("Error", "This subcategory cannot be opened.");
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}