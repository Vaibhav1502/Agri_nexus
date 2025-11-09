import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/controller/global_controller.dart';
import 'package:agri_nexus_ht/app/controller/network_controller.dart';
import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:agri_nexus_ht/app/modules/home/category_controller.dart';
import 'package:agri_nexus_ht/app/modules/home/home_controller.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:agri_nexus_ht/app/modules/wishlist/wishlist_controller.dart';
import 'package:agri_nexus_ht/app/navigation/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/theme.dart';


// Create an async function to initialize services
Future<void> initServices() async {
  print("--- Initializing App Services & Controllers ---");
  Get.put(NetworkController(), permanent: true);
  Get.put(GlobalController(), permanent: true);
  // Put AuthController and tell GetX to wait until its onReady is called.
  // We will make it permanent here.
  await Get.putAsync(() => AuthController().init(), permanent: true);

   Get.put(HomeController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  Get.put(WishlistController(), permanent: true);
   Get.put(CategoryController(), permanent: true);
  
  print("--- Services & Controllers are ready ---");
  
}


void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  // Call our new init function
  await initServices();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       navigatorKey: navigatorKey,
      title: 'Nexus Agriculture',
      theme: AppTheme.lightTheme,
      // The initial route will now be handled by the SplashController logic
      initialRoute: AppRoutes.splash, 
      getPages: AppPages.pages,
      // ... your theme data etc.
    );
  }
}

// void main() {
//   runApp(
//     GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       initialRoute: AppRoutes.splash,
//       getPages: AppPages.pages,
//     ),
//   );
// }