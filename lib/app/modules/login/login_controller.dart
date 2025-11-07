import 'dart:convert';
import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/modules/delar/dealer_registration_form_view.dart';
import 'package:agri_nexus_ht/app/modules/home/home_controller.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:agri_nexus_ht/app/services/avigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/storage_service.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final storageService = StorageService();
  final authController = Get.find<AuthController>(); // 👈 Get instance of AuthController
  final profileController = Get.find<ProfileController>(); // Find the permanent instance

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

       // Clear old data for a clean login
      await storageService.clearToken();
      await storageService.clearUser();
      authController.clearUser();

    final url = Uri.parse('https://nexus.heuristictechpark.com/api/v1/login');
    final body = {"email": email, "password": password};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final token = data["data"]["token"];
        //final userData = data["data"]["user"];  
        // print("✅ LOGGING IN USER: $userData"); // <-- ADD THIS  
        await storageService.saveToken(token);
        //await authController.saveUser(userData); // Save the user data

        // 2. THIS IS THE FIX: Fetch the LATEST, FULL profile from the server.
        // This will update the global AuthController with the fresh, correct state.
        print("🚀 Login successful. Refreshing full user profile...");
        await profileController.fetchAndUpdateUserProfile();
        print("✅ Full user profile refreshed.");

        // // 👇 --- ADD THIS BLOCK TO REFRESH DATA --- 👇
        // // Check if HomeController is already in memory and refresh it.
        // if (Get.isRegistered<HomeController>()) {
        //   final homeController = Get.find<HomeController>();
        //   await homeController.fetchProducts();
        //   print("🔄 Products have been re-fetched after login.");
        // }
        // // 👆 --- END OF REFRESH BLOCK --- 👆

        
        Get.snackbar("Success", "Login successful!", backgroundColor: Colors.green.shade600, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10),duration: Duration(seconds: 2),animationDuration: const Duration(milliseconds: 600));
         NavigationService().redirectUser(); 
         //_redirectUser(); // 👈 CALL THE REDIRECT LOGIC
        // Future.delayed(const Duration(milliseconds: 800), () {
        //   Get.offAllNamed(AppRoutes.home);
        // });
      } else {
        Get.snackbar("Failed", data["message"] ?? "Login failed", backgroundColor: Colors.green.shade600, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10),duration: Duration(seconds: 2),animationDuration: const Duration(milliseconds: 600));
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // void _redirectUser() {
  //    // This will now be 100% reliable as the state is updated just before this is called.
  //   final authController = Get.find<AuthController>();
  //   print("LoginRedirect: Checking user role for redirection...");
  //   final user = authController.currentUser.value;
  //   if (user == null) {
  //     Get.offAllNamed(AppRoutes.login);
  //     return;
  //   }

  //   final isDealer = user['role'] == 'dealer';
  //   final hasCompletedProfile = authController.hasCompletedDealerProfile;

  //    print("LoginRedirect: isDealer=$isDealer, hasCompletedProfile=$hasCompletedProfile");


  //   if (isDealer && !hasCompletedProfile) {
  //     // Dealer who has NOT filled the form -> Go to Form
  //     Get.offAll(() => DealerRegistrationFormView());
  //   } else if (isDealer && hasCompletedProfile) {
  //     // Dealer who HAS filled the form -> Go Home (pricing logic will handle the rest)
  //     Get.offAllNamed(AppRoutes.home);
  //   } else {
  //     // Customer -> Go Home
  //     Get.offAllNamed(AppRoutes.home);
  //   }
  // }


  Future<void> logoutUser() async {
  final token = await storageService.getToken();
  if (token == null) {
    Get.snackbar("Error", "No active session found");
    return;
  }

  final url = Uri.parse('https://nexus.heuristictechpark.com/api/v1/logout');

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      // optional if required by backend:
      // body: jsonEncode({"email": "john@example.com", "password": "password123"}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      await storageService.clearToken();
       await authController.clearUser(); // Also clear user data
      Get.snackbar("Success", data["message"] ?? "Logged out successfully", backgroundColor: Colors.green.shade600, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(10),duration: Duration(seconds: 2),animationDuration: const Duration(milliseconds: 600));
      Get.offAllNamed(AppRoutes.login);
    } else {
      Get.snackbar("Error", data["message"] ?? "Logout failed");
    }
  } catch (e) {
    Get.snackbar("Error", "Something went wrong: $e");
  }
}
}
