// app/data/providers/dealer_provider.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/storage_service.dart';

import 'package:agri_nexus_ht/api_config.dart';

class DealerProvider {
  final storageService = StorageService();

  Future<void> submitDealerRegistration(Map<String, dynamic> details) async {
    final url = Uri.parse('$baseUrl/dealer/register');
    final token = await storageService.getToken();

    
    // 👇 --- THIS IS THE MOST IMPORTANT DEBUG STEP --- 👇
    print("--- 🔑 USING TOKEN FOR SUBMISSION ---");
    print(token);
    print("----------------------------------");
    // 👆 --- END OF DEBUG STEP --- 👆

    if (token == null) {
      throw Exception('Authentication token not found. Please log in again.');
    }

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(details),
    );

    // Treat any 2xx as success (e.g., 200 OK, 201 Created)
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to submit details');
    }
  }
}