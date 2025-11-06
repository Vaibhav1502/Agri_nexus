import 'dart:convert';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductDetailProvider {
  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1';
  final storageService = StorageService(); // 👈 GET an instance

  Future<Product> fetchProductDetail(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');
     final token = await storageService.getToken(); // 👈 GET THE TOKEN
     // 👇 ADD HEADERS TO THE HTTP REQUEST
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    // 👆 END of changes to the request

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final productData = jsonData['data'];
      return Product.fromJson(productData);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}
