import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/storage_service.dart';
import 'product_model.dart';

import 'package:agri_nexus_ht/api_config.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  final storage = StorageService();

    @override
  void onInit() {
    super.onInit();
    // 👇 Fetch all products immediately when the controller is created
    fetchAllProducts();
  }

   Future<void> fetchAllProducts() async {
    isLoading(true);
    try {
      final token = await storage.getToken();
      // Use the main products endpoint
      final url = Uri.parse("https://nexus.heuristictechpark.com/api/v1/products"); 

      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Check if the data is paginated (inside 'data' -> 'data') or a direct list
        final dataList = body['data']['data'] ?? []; 
        products.value = (dataList as List).map((e) => ProductModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      print("Error fetching all products: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchProducts(String query) async {
    isLoading(true);
    final token = await storage.getToken();

    final url = Uri.parse("$baseUrl/products/search?q=$query&per_page=10&page=1");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final data = body['data']['data'] as List;
      products.value = data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      products.clear();
      Get.snackbar('Error', 'Failed to load products');
    }
    isLoading(false);
  }
}
