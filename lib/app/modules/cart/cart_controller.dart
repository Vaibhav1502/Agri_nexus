import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/storage_service.dart';

class CartController extends GetxController {
  final storageService = StorageService();

  var isLoading = false.obs;
  var cartItems = [].obs;
  var subtotal = 0.0.obs;
  var taxAmount = 0.0.obs;
  var shippingAmount = 0.0.obs;
  var total = 0.0.obs;
  var cartCount = 0.obs;

  /// 🛒 Fetch Cart Items
  Future<void> fetchCart() async {
    try {
      isLoading(true);

      final token = await storageService.getToken();
      if (token == null) {
        print("❌ No token found, user not logged in");
        Get.snackbar("Error", "Please login first to view your cart");
        return;
      }

      final response = await http.get(
        Uri.parse("https://nexus.heuristictechpark.com/api/v1/cart"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final cartData = data['data'];
          cartItems.value = cartData['items'];
          subtotal.value = (cartData['subtotal'] ?? 0).toDouble();
          taxAmount.value = (cartData['tax_amount'] ?? 0).toDouble();
          shippingAmount.value =
              (cartData['shipping_amount'] ?? 0).toDouble();
          total.value = (cartData['total'] ?? 0).toDouble();
        }
      } else {
        print("❌ Error fetching cart: ${response.body}");
      }
    } catch (e) {
      print("Error fetching cart: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ➕ Add Product to Cart
  Future<void> addToCart(int productId, {int quantity = 1}) async {
    try {
      isLoading(true);
      

      final token = await storageService.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please login first",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await http.post(
        Uri.parse("https://nexus.heuristictechpark.com/api/v1/cart/add"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", 
        },
        body: jsonEncode({
          "product_id": productId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          Get.snackbar(
            "Success",
            data["message"] ?? "Product added to cart!",
             backgroundColor: Colors.green.shade600, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10),duration: Duration(seconds: 2),animationDuration: const Duration(milliseconds: 600)
          );
          await fetchCart();
          await fetchCartCount();
        } else {
          Get.snackbar(
            "Error",
            data["message"] ?? "Failed to add product",
            backgroundColor: Colors.red.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server error: ${response.statusCode}",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error adding to cart: $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// 🔄 Update Cart Quantity
  Future<void> updateCartItem(int productId, int newQuantity) async {
    try {
      isLoading(true);
     

      final token = await storageService.getToken();
      if (token == null) {
        Get.snackbar("Error", "Please login first",
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final response = await http.put(
        Uri.parse("https://nexus.heuristictechpark.com/api/v1/cart/update"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "product_id": productId,
          "quantity": newQuantity,
        }),
      );

     

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          Get.snackbar(
            "Success",
            data["message"] ?? "Cart updated successfully!",
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );
          await fetchCart();
          await fetchCartCount();
        } else {
          Get.snackbar(
            "Error",
            data["message"] ?? "Failed to update cart",
            backgroundColor: Colors.red.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server error: ${response.statusCode}",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error updating cart: $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeFromCart(int productId) async {
  try {
    isLoading(true);
   

    final token = await storageService.getToken(); // get auth token

    final response = await http.delete(
      Uri.parse("https://nexus.heuristictechpark.com/api/v1/cart/remove/$productId"),
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        Get.snackbar(
          "Removed",
          data["message"] ?? "Product removed from cart!",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
        await fetchCart(); // refresh the cart
        await fetchCartCount();
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed to remove product",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Server error: ${response.statusCode}",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print("❌ Error removing from cart: $e");
    Get.snackbar(
      "Error",
      "Something went wrong while removing item",
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
    );
  } finally {
    isLoading(false);
  }
}

Future<void> clearCart() async {
  try {
    isLoading(true);
    print("🧹 Clearing entire cart...");

    final token = await storageService.getToken(); // get auth token if needed

    final response = await http.delete(
      Uri.parse("https://nexus.heuristictechpark.com/api/v1/cart/clear"),
      headers: {
        "Accept": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    print("🧹 Response: ${response.statusCode} | ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        Get.snackbar(
          "Cart Cleared",
          data["message"] ?? "All items removed from cart!", backgroundColor: Colors.green.shade600, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10),duration: Duration(seconds: 2),animationDuration: const Duration(milliseconds: 600),
        );
        await fetchCart(); // refresh cart view
        await fetchCartCount();
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed to clear cart",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Server error: ${response.statusCode}",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print("❌ Error clearing cart: $e");
    Get.snackbar(
      "Error",
      "Something went wrong while clearing the cart",
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
    );
  } finally {
    isLoading(false);
  }
}

Future<void> fetchCartCount() async {
  try {
    isLoading.value = true;
    final token = await storageService.getToken();

    final response = await http.get(
      Uri.parse("https://nexus.heuristictechpark.com/api/v1/cart/count"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      cartCount.value = data['data']['count'] ?? 0;
      debugPrint("🛒 Cart count: ${cartCount.value}");
    } else {
      debugPrint("⚠️ Failed to fetch cart count: ${data['message']}");
    }
  } catch (e) {
    debugPrint("❌ Error fetching cart count: $e");
  } finally {
    isLoading.value = false;
  }
 
}
   
}
