import 'dart:convert';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

import 'package:agri_nexus_ht/api_config.dart';

class FeaturedProductProvider {
 
  final storageService = StorageService(); // 👈 GET an instance


  Future<List<Product>> fetchFeaturedProducts() async {
    final url = Uri.parse('$baseUrl/products/featured');
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
      final List data = jsonData["data"];
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load featured products");
    }
  }
}
