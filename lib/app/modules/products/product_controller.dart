import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/storage_service.dart';
import 'product_model.dart';

class ProductController extends GetxController {
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  final storage = StorageService();

  Future<void> searchProducts(String query) async {
    isLoading(true);
    final token = await storage.getToken();

    final url = Uri.parse(
        "https://nexus.heuristictechpark.com/api/v1/products/search?q=$query&per_page=10&page=1");

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
