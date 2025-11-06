import 'dart:convert';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WishlistController extends GetxController {
   final storageService = StorageService();
  //final storage = const FlutterSecureStorage();

  var isLoading = false.obs;
  var wishlistItems = [].obs;
  

  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1';

  /// ✅ Fetch Wishlist
  Future<void> fetchWishlist() async {
    isLoading.value = true;
    final token = await storageService.getToken();
     
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        wishlistItems.value = data['data'];
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to fetch wishlist');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

   /// ❤️ Add to Wishlist
  Future<void> addToWishlist(int productId) async {
    final token = await storageService.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist/add'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'product_id': productId.toString(),
        },
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar('Success', data['message'] ?? 'Added to wishlist ❤️');
        fetchWishlist(); // Refresh list
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to add');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }


  /// 💔 Remove from Wishlist
Future<void> removeFromWishlist(int productId) async {
  final token = await storageService.getToken();

  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/remove/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      Get.snackbar('Removed', data['message'] ?? 'Removed from wishlist 💔');
      fetchWishlist(); // Refresh the list after removal
    } else {
      Get.snackbar('Error', data['message'] ?? 'Failed to remove');
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong');
  }
}

/// 🧹 Clear Wishlist
Future<void> clearWishlist() async {
  final token = await storageService.getToken();

  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/wishlist/clear'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      wishlistItems.clear(); // instantly clear UI
      Get.snackbar('Cleared', data['message'] ?? 'Wishlist cleared successfully');
    } else {
      Get.snackbar('Error', data['message'] ?? 'Failed to clear wishlist');
    }
  } catch (e) {
    Get.snackbar('Error', 'Something went wrong');
  }
}

}
