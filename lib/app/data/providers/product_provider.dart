import 'dart:convert';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

import 'package:agri_nexus_ht/api_config.dart';

class ProductProvider {
  
  final storageService = StorageService(); // Get instance

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products');
     final token = await storageService.getToken(); // 👈 GET THE TOKEN
     // 👇 ADD HEADERS TO THE REQUEST
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );


    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List products = jsonData["data"]["data"];
      return products.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

   /// 🔍 Search products by query
  Future<List<Product>> searchProducts(String query) async {
    final url = Uri.parse('$baseUrl/products/search?q=$query&per_page=10&page=1');
     final token = await storageService.getToken(); // 👈 GET THE TOKEN
      // 👇 ADD HEADERS TO THE REQUEST
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      // Handle empty or unexpected structure gracefully
      if (jsonData["data"] == null || jsonData["data"]["data"] == null) {
        return [];
      }

      final List products = jsonData["data"]["data"];
      return products.map((p) => Product.fromJson(p)).toList();
    } else {
      throw Exception("Failed to search products");
    }
  }
}
