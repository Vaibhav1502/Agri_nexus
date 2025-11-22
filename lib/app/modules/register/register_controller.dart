import 'dart:convert';
import 'package:agri_nexus_ht/app/data/providers/dealer_provider.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/services/avigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/storage_service.dart';
import '../../routes/app_pages.dart';

import 'package:agri_nexus_ht/api_config.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  final storageService = StorageService();

   // Reuse the DealerProvider to handle the business submission
  final dealerProvider = DealerProvider();
  // We need ProfileController to refresh state after registration
  final profileController = Get.put(ProfileController()); 

  var isPasswordHidden = true.obs;

  // --- FORM CONTROLLERS ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Dealer Specific Controllers
  final businessNameController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  var termsAccepted = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> registerUser({
    
    required String role,
  }) async {
     if (phoneController.text.length != 10) {
      Get.snackbar("Error", "Phone number must be 10 digits.");
      // We might want to stop the loading indicator if validation fails early.
      isLoading.value = false;
      return;
    }

     // 2. DEALER SPECIFIC VALIDATION
    if (role == 'dealer') {
       if (!termsAccepted.value) {
        Get.snackbar("Error", "Please accept the terms and conditions.");
        return;
      }
      // Add specific GST/Empty checks here if not handled by UI form key
    }
    isLoading.value = true;

    final url = Uri.parse('$baseUrl/register');
    final registerBody = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "password_confirmation": passwordController.text.trim(),
      "role": role,
      "phone": phoneController.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(registerBody),
      );

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) && data["success"] == true) {
        final token = data["data"]["token"];
        await storageService.saveToken(token);
        print("✅ User Registered. Token saved.");

         if (role == 'dealer') {
          print("🚀 Step 2: Submitting Dealer Business Details...");
          
          final dealerDetails = {
            // User info again (required by your specific endpoint)
            "name": nameController.text.trim(),
            "email": emailController.text.trim(),
            "phone": phoneController.text.trim(),
            
            // Business info
            "business_name": businessNameController.text.trim(),
            "gst_number": gstController.text.trim(),
            "business_address": addressController.text.trim(),
            "company_website": websiteController.text.trim(),
            "business_description": descriptionController.text.trim(),
            "terms_accepted": true,
          };

          // 👇 --- ADD THIS LOG --- 👇
  print("--- 📤 DEALER PAYLOAD ---");
  print(jsonEncode(dealerDetails));
  print("-----------------------");
  // 👆 -------------------- 👆

          // Use the existing provider logic which handles the token header
          await dealerProvider.submitDealerRegistration(dealerDetails);
          print("✅ Dealer Details Submitted.");
        }

        Get.snackbar("Success", "Registration Successful!");

         // Refresh profile to get the full state (including business_name)
        await profileController.fetchAndUpdateUserProfile();
        // 👇 Navigate to login screen
         NavigationService().redirectUser();
        // await Future.delayed(const Duration(seconds: 2)); // Give user time to see snackbar
        // Get.offNamed(AppRoutes.login);
      } else {
        Get.snackbar("Error", data["message"] ?? "Registration failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
