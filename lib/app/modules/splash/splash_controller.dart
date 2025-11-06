// splash_controller.dart

import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/modules/delar/dealer_registration_form_view.dart';
import 'package:agri_nexus_ht/app/services/avigation_service.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';


class SplashController extends GetxController {
  
  @override
  void onReady() { // Use onReady, which runs after the widget is rendered
    super.onReady();
    _initializeApp();
  }

   Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    // Just call the central navigation service. It will handle everything.
    NavigationService().redirectUser(); 
  }

}

//   Future<void> _initializeApp() async {
//     // A small delay for the splash screen effect
//     await Future.delayed(const Duration(seconds: 2));

//     // AuthController is already initialized by main.dart, so we can just find it.
//     final authController = Get.find<AuthController>();

//     if (authController.isLoggedIn) {
//       // User is logged in, decide where to go
//       _redirectUser(authController);
//     } else {
//       // Not logged in
//       Get.offAllNamed(AppRoutes.login);
//     }
//   }

//   void _redirectUser(AuthController authController) {
//     print("SplashRedirect: Checking user role for redirection...");
//     final user = authController.currentUser.value;
    
//     // This check is now reliable because we waited for the data to load.
//     if (user == null) {
//       Get.offAllNamed(AppRoutes.login);
//       return;
//     }

//     final isDealer = user['role'] == 'dealer';
//     final hasCompletedProfile = authController.hasCompletedDealerProfile;

//     print("SplashRedirect: isDealer=$isDealer, hasCompletedProfile=$hasCompletedProfile");

//     if (isDealer && !hasCompletedProfile) {
//       Get.offAll(() => DealerRegistrationFormView());
//     } else {
//       // This covers both approved dealers and customers
//       Get.offAllNamed(AppRoutes.home);
//     }
//   }
// }

// // splash_controller.dart

// import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
// import 'package:agri_nexus_ht/app/modules/delar/dealer_registration_form_view.dart';
// import 'package:get/get.dart';
// import '../../services/storage_service.dart';
// import '../../routes/app_pages.dart';
// // 👈 Import

// class SplashController extends GetxController {
//   final storageService = StorageService();

//   @override
//   void onReady() { // Use onReady, which runs after the widget is rendered
//     super.onReady();
//     _initializeApp();
//   }

//   Future<void> _initializeApp() async {
//     // Initialize AuthController so it's available globally.
//     // This will also trigger its onInit to load user data from storage.

//      final authController = Get.put(AuthController(), permanent: true);
//    // Get.put(AuthController(), permanent: true);

//     await Future.delayed(const Duration(seconds: 2)); // Splash delay

//     final token = await storageService.getToken();
//     if (token != null && token.isNotEmpty) {
//        _redirectUser(authController);
//       //Get.offAllNamed(AppRoutes.home);
//     } else {
//       Get.offAllNamed(AppRoutes.login);
//     }
//   }

//   void _redirectUser(AuthController authController) {
//     final user = authController.currentUser.value;
//     if (user == null) {
//       Get.offAllNamed(AppRoutes.login);
//       return;
//     }

//     final isDealer = user['role'] == 'dealer';
//     final hasCompletedProfile = authController.hasCompletedDealerProfile;

//     if (isDealer && !hasCompletedProfile) {
//       Get.offAll(() => DealerRegistrationFormView());
//     } else if (isDealer && hasCompletedProfile) {
//       Get.offAllNamed(AppRoutes.home);
//     } else {
//       Get.offAllNamed(AppRoutes.home);
//     }
//   }
// }