// app/modules/checkout/checkout_controller.dart

import 'dart:convert';

import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/controller/network_controller.dart';
import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CheckoutController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final networkController = Get.find<NetworkController>();
  final authController = Get.find<AuthController>();
  final cartController = Get.find<CartController>();
  final storageService = StorageService();

  var isLoading = false.obs;

  // Text controllers for the form fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final billingAddressController = TextEditingController();
  final shippingAddressController = TextEditingController();
  final notesController = TextEditingController();

  var useSameAddress = true.obs; // For the "Shipping same as Billing" checkbox

  @override
  void onInit() {
    super.onInit();
    // Pre-fill the form with the logged-in user's data
    final user = authController.currentUser.value;
    if (user != null) {
      nameController.text = user['name'] ?? '';
      emailController.text = user['email'] ?? '';
      phoneController.text = user['phone'] ?? '';
    }

    // When the checkbox value changes, update the shipping address controller
    ever(useSameAddress, (isSame) {
      if (isSame) {
        shippingAddressController.text = billingAddressController.text;
      } else {
        shippingAddressController.clear();
      }
    });

    // Also listen to changes in the billing address field
    billingAddressController.addListener(() {
      if (useSameAddress.value) {
        shippingAddressController.text = billingAddressController.text;
      }
    });
  }

  /// Submits the order to the backend
  Future<void> placeOrder() async {
    // 1. Check for internet connection
    if (!networkController.isOnline.value) {
      Get.snackbar("Error", "No internet connection.");
      return;
    }

    // 2. Validate the form
    if (formKey.currentState?.validate() != true) {
      Get.snackbar("Error", "Please fill in all required fields correctly.");
      return;
    }

    isLoading.value = true;
    try {
      final token = await storageService.getToken();
      final url = Uri.parse("https://nexus.heuristictechpark.com/api/v1/orders");

      // 3. Construct the request body from the controllers
      final body = {
        "customer_name": nameController.text.trim(),
        "customer_email": emailController.text.trim(),
        "customer_phone": phoneController.text.trim(),
        "billing_address": billingAddressController.text.trim(),
        "shipping_address": shippingAddressController.text.trim(),
        "notes": notesController.text.trim(),
      };

      // 4. Make the API call
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      // 5. Handle the response
      if (response.statusCode == 200 && data['success'] == true) {
        // Order placed successfully!
        Get.snackbar(
          "Success!",
          data['message'] ?? "Your order has been placed successfully.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear the cart and navigate to the home or orders screen
        await cartController.clearCart();
        Get.offAllNamed(AppRoutes.home); // Or navigate to your orders page
        
      } else {
        // Handle errors, like an empty cart
        Get.snackbar(
          "Order Failed",
          data['message'] ?? "Something went wrong. Please try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}