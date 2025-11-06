import 'dart:convert';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderController extends GetxController {
  final storageService = StorageService();
  var isLoading = false.obs;
  var orders = [].obs;

  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1';

  /// 🧾 Fetch Orders
  Future<void> fetchOrders() async {
    isLoading.value = true;
    final token = await storageService.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        orders.value = data['data']['data']; // Orders list inside pagination
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to load orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while fetching orders');
    } finally {
      isLoading.value = false;
    }
  }
}
