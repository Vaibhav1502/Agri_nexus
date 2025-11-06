// app/services/navigation_service.dart


import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/modules/delar/dealer_registration_form_view.dart';
import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NavigationService {
  void redirectUser() {
    try { // Add a try-catch block to catch any hidden errors
      print("--- 🚦 NavigationService: redirectUser() CALLED ---");

      final authController = Get.find<AuthController>();

      if (!authController.isLoggedIn) {
        print("🚦 Decision: User not logged in. Navigating to LOGIN.");
        Get.offAllNamed(AppRoutes.login);
        return;
      }


    final user = authController.currentUser.value!;
      final isDealer = user['role'] == 'dealer';
      final hasCompletedProfile = authController.hasCompletedDealerProfile;

      print("🚦 State Check: isDealer=$isDealer, hasCompletedProfile=$hasCompletedProfile");

      if (isDealer && !hasCompletedProfile) {
        print("🚦 Decision: Incomplete dealer profile. Navigating to DEALER FORM.");
        Get.offAll(() => DealerRegistrationFormView());
      } else {
        print("🚦 Decision: Customer or Complete Dealer. Navigating to HOME.");
        Get.offAllNamed(AppRoutes.home);
      }
      print("--- 🚦 NavigationService: Navigation command ISSUED ---");
    } catch (e) {
      print("🔥🔥🔥 CRITICAL ERROR in NavigationService: $e 🔥🔥🔥");
      // Show an error to the user so they know something is wrong
      Get.snackbar("Navigation Error", "An unexpected error occurred: $e");
    }
  }
}