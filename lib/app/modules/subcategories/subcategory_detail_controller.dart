// app/modules/subcategories/subcategory_detail_controller.dart

import 'dart:convert';

import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/data/models/product_model.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SubcategoryDetailController extends GetxController {
  final storageService = StorageService();
  final authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var subcategoryName = ''.obs;
  var subcategoryDescription = ''.obs;
  var products = <Product>[].obs;
  
  String? _currentSubcategorySlug;

  @override
  void onInit() {
    super.onInit();
    // Add the reactive listener for auth changes
    ever(authController.currentUser, (_) {
      if (_currentSubcategorySlug != null) {
        fetchSubcategoryDetails(_currentSubcategorySlug!);
      }
    });
  }

  // This is the core method for this controller
  Future<void> fetchSubcategoryDetails(String subcategorySlug) async {
    _currentSubcategorySlug = subcategorySlug;
    if (isLoading.value) return;

    try {
      isLoading(true);
      print("🚀 Fetching SUBCATEGORY details for SLUG: $subcategorySlug");
      
      final token = await storageService.getToken();
      
      // 👇 --- THIS IS THE ONLY MAJOR CHANGE --- 👇
      // Point to the new subcategories endpoint
      final url = Uri.parse("https://nexus.heuristictechpark.com/api/v1/subcategories/$subcategorySlug");
      // 👆 --- END OF CHANGE --- 👆
      
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"] == true) {
          // The key is 'subcategory' instead of 'category'
          final subcategoryData = data["data"]["subcategory"];
          subcategoryName.value = subcategoryData["name"] ?? "";
          subcategoryDescription.value = subcategoryData["description"] ?? "";

          final productList = data["data"]["products"]["data"] as List;
          products.value = productList.map((e) => Product.fromJson(e)).toList();
        }
      } else {
        Get.snackbar("Error", "Failed to load subcategory products. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching subcategory details: $e");
    } finally {
      isLoading(false);
    }
  }
}