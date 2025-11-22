// app/modules/subcategories/subcategory_controller.dart

import 'dart:convert';
import 'package:agri_nexus_ht/app/data/models/subcategory_model.dart'; // We can reuse our existing model
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:agri_nexus_ht/api_config.dart';

class SubcategoryController extends GetxController {
  var isLoading = false.obs;
  var subcategories = <Subcategory>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchAllSubcategories();
  }

  Future<void> fetchAllSubcategories() async {
    // You can add a network guard here if you like
    if (isLoading.value) return;

    try {
      isLoading(true);
      print("🚀 Fetching all subcategories...");
      final response = await http.get(Uri.parse('$baseUrl/subcategories'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          final List subcategoryData = data['data'];
          subcategories.value = subcategoryData.map((json) => Subcategory.fromJson(json)).toList();
          print("✅ Found ${subcategories.length} subcategories.");
        }
      } else {
        Get.snackbar("Error", "Failed to load subcategories.");
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      Get.snackbar("Error", "Something went wrong.");
    } finally {
      isLoading(false);
    }
  }
}