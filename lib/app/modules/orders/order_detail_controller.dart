// app/modules/orders/order_detail_controller.dart

import 'dart:convert';
import 'package:agri_nexus_ht/app/data/models/order_model.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:agri_nexus_ht/api_config.dart';

class OrderDetailController extends GetxController {
  final storageService = StorageService();
  var isLoading = false.obs;
  var order = Rxn<Order>(); // Observable for a single Order object

  /// Fetches details for a specific order by its order number
  Future<void> fetchOrderDetail(String orderNumber) async {
    isLoading.value = true;
    final token = await storageService.getToken();
    if (token == null) {
      Get.snackbar("Error", "Authentication failed.");
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderNumber'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        order.value = Order.fromJson(data['data']);
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to load order details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}