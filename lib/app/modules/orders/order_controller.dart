import 'dart:convert';
import 'package:agri_nexus_ht/app/data/models/order_model.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OrderController extends GetxController {
  final storageService = StorageService();
  var isLoading = false.obs;
   var orders = <Order>[].obs;

  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1';

  /// 🧾 Fetch Orders
  Future<void> fetchOrders() async {
     print("--- 🚀 Fetching Orders ---");
    isLoading.value = true;
    final token = await storageService.getToken();
    if (token == null) {
      print("❌ No token found. Aborting fetchOrders.");
      isLoading.value = false;
      return;
    }

    print("🔑 Using token: $token");// This line is crucial

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );

       // 👇 --- THIS IS THE CRITICAL PART - ADD THIS LOGGING --- 👇
      print("--- 📝 Order API Response ---");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("---------------------------");
      // 👆 --- END OF LOGGING --- 👆

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
       final List orderData = data['data']['data'];
       print("✅ Found ${orderData.length} orders in the API response.");
        orders.value = orderData.map((orderJson) => Order.fromJson(orderJson)).toList();
      } else {
         print("API reported success=false or status code was not 200.");
        Get.snackbar('Error', data['message'] ?? 'Failed to load orders');
      }
    } catch (e) {
        print("🔥🔥🔥 Exception in fetchOrders: $e");
      Get.snackbar('Error', 'Something went wrong while fetching orders');
    } finally {
      isLoading.value = false;
    }
  }
}
