// app/modules/dealer/dealer_registration_form_controller.dart

import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/data/providers/dealer_provider.dart';
import 'package:agri_nexus_ht/app/modules/login/login_controller.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/navigation/navigator_key.dart';
import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:agri_nexus_ht/app/services/avigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pending_approval_view.dart';

class DealerRegistrationFormController extends GetxController {
   final formKey = GlobalKey<FormState>(); // 👈 Add the form key
  final _provider = DealerProvider();
  final authController = Get.find<AuthController>(); // 👈 GET INSTANCE of AuthController
 final profileController = Get.find<ProfileController>(); // 👈 GET an instance
  var isLoading = false.obs;
  


  final businessNameController = TextEditingController();
  final gstController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  var termsAccepted = false.obs;

  Future<void> submitRegistration() async {

     // 👇 --- VALIDATE THE FORM FIRST --- 👇
    if (formKey.currentState?.validate() != true) {
      Get.snackbar("Invalid Input", "Please correct the errors on the form.");
      return; // Stop if validation fails
    }
    // 👆 --- END OF VALIDATION --- 👆
    
       // Basic validation
    if (businessNameController.text.trim().isEmpty ||
        gstController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar("Input Required", "Please fill in all required fields.");
      return;
    }
    
    if (!termsAccepted.value) {
      Get.snackbar("Error", "You must accept the terms and conditions.");
      return;
    }

    // 👇 --- THIS IS THE FIX --- 👇
    // Get the current user's data
    final currentUser = authController.currentUser.value;
    if (currentUser == null) {
      Get.snackbar("Error", "Could not find user data. Please log in again.");
      return;
    }

    final details = {
       "name": currentUser['name'],
      "email": currentUser['email'],
      "phone": currentUser['phone'].toString(),
      "business_name": businessNameController.text,
      "gst_number": gstController.text,
      "business_address": addressController.text,
      "company_website": websiteController.text,
      "business_description": descriptionController.text,
      "terms_accepted": termsAccepted.value,
    };

    // Let's print the payload to be 100% sure what we are sending
    print("--- 📤 Submitting Dealer Payload ---");
    print(details);
    print("---------------------------------");


    isLoading.value = true;
    try {
      await _provider.submitDealerRegistration(details);
      await profileController.fetchAndUpdateUserProfile();
      Get.snackbar("Success", "Your business details have been submitted for approval.");
         // 👇 --- USE THE CLEAN NAVIGATION METHOD --- 👇
      // This will work now that the controller conflicts are resolved.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService().redirectUser();
      });
      // 👆 --- END OF FIX --- 👆
      
    } catch (e) {
      // If the error is still "Validation failed", the backend has a specific rule we are breaking.
      Get.snackbar("Submission Error", "Something went wrong on server. Please try again later.");
     // Get.snackbar("Submission Error", e.toString());
      print("❌ Backend Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}