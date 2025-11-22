import 'package:agri_nexus_ht/app/controller/network_controller.dart';
import 'package:agri_nexus_ht/app/data/models/category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:agri_nexus_ht/api_config.dart';

class CategoryController extends GetxController {
   final networkController = Get.find<NetworkController>();
  var categories = <Category>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
     ever(networkController.isOnline, (isOnline) {
      // If the device comes online AND we don't have any categories yet,
      // then try to fetch them.
      if (isOnline && categories.isEmpty) {
        print("Network is back online. Fetching categories...");
        fetchCategories();
      }
    });
    fetchCategories();
  }

  Future<void> fetchCategories() async {
     // Add the network guard here as well for consistency.
    if (!networkController.isOnline.value) {
      print("Offline: Skipping fetchCategories().");
      return;
    }
    
    // Prevent multiple calls if already loading
    if (isLoading.value) return;

    try {
      isLoading(true);
      final response = await http.get(Uri.parse('$baseUrl/categories'),);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          categories.value = (data['data'] as List)
              .map((e) => Category.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading(false);
    }
  }
}
