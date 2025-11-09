// app/modules/subcategories/all_subcategories_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'subcategory_controller.dart';

class AllSubcategoriesView extends StatelessWidget {
  const AllSubcategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubcategoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Subcategories"),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.subcategories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.subcategories.isEmpty) {
          return const Center(child: Text("No subcategories found."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAllSubcategories(),
          child: ListView.builder(
            itemCount: controller.subcategories.length,
            itemBuilder: (context, index) {
              final subcategory = controller.subcategories[index];
              return ListTile(
                leading: const Icon(Icons.label),
                title: Text(subcategory.name),
                // You could display the parent category here if you update the model
                // subtitle: Text(subcategory.category.name), 
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to a new "Subcategory Detail View"
                  // This will require a new screen and controller similar to CategoryDetail
                  if (subcategory.slug != null && subcategory.slug!.isNotEmpty) {
        Get.toNamed('/subcategory-detail', arguments: subcategory.slug);
      }
                },
              );
            },
          ),
        );
      }),
    );
  }
}