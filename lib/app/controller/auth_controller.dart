// app/controllers/auth_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import '../services/storage_service.dart'; // Make sure the path is correct

class AuthController extends GetxController {
  final storageService = StorageService();
  var currentUser = Rxn<Map<String, dynamic>>();

   // This is the new init method that Get.putAsync will wait for.
  Future<AuthController> init() async {
    await loadUserFromStorage();
    return this;
  }

  // A computed property to easily check if the user is an approved dealer

  bool get isPendingDealer {
    if (!isLoggedIn || currentUser.value!['role'] != 'dealer') {
      return false;
    }
    // They are pending if they have completed the form but are not yet approved.
    return hasCompletedDealerProfile && !isApprovedDealer;
  }

   // 👇 --- ADD THIS NEW GETTER --- 👇
  /// Checks if a user with the 'dealer' role has filled out their business details.
   // 👇 --- REPLACE your old getter with this new one --- 👇
  bool get hasCompletedDealerProfile {
    print("--- 🕵️ DEBUGGING hasCompletedDealerProfile 🕵️ ---");

    if (currentUser.value == null) {
      print("🕵️ Result: FALSE (currentUser is null)");
      return false;
    }

    if (currentUser.value!['role'] != 'dealer') {
      print("🕵️ Result: FALSE (User is not a dealer, role is '${currentUser.value!['role']}')");
      return false; // Not a dealer, so no profile to complete.
    }

    // Now, let's check for the signals that the profile is complete.
    // The most reliable signal is the presence of a business name.
    
    final businessName = currentUser.value!['business_name'];
    
    print("🕵️ Checking business_name: The value is -> [${businessName}]");
    print("🕵️ Type of business_name: ${businessName.runtimeType}");

    // A completed profile will have a non-null, non-empty string.
    bool isProfileComplete = businessName != null && businessName.toString().isNotEmpty;

    print("🕵️ Final Verdict: hasCompletedDealerProfile is -> $isProfileComplete");
    print("-------------------------------------------------");
    
    return isProfileComplete;
  }
  // 👆 --- End of replacement --- 👆


  bool get isApprovedDealer {
  if (currentUser.value == null) {
    print("🕵️ Auth Check: currentUser is NULL.");
    return false;
  }

  bool isDealer = currentUser.value!['role'] == 'dealer';
  bool isApproved = currentUser.value!['is_dealer_approved'] == true;

  // This print statement is GOLD. It will run every time the getter is used.
  print("🕵️ Auth Check: Role is '${currentUser.value!['role']}' ($isDealer), Is Approved is '${currentUser.value!['is_dealer_approved']}' ($isApproved).");
  
  return isDealer && isApproved;
}
  // bool get isApprovedDealer {
  //   if (currentUser.value == null) return false;
    
  //   bool isDealer = currentUser.value!['role'] == 'dealer';
  //   bool isApproved = currentUser.value!['is_dealer_approved'] == true;
    
  //   return isDealer && isApproved;
  // }

  // Check if a user is logged in
  bool get isLoggedIn => currentUser.value != null;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // Try to load user data from storage when the app starts
  //   loadUserFromStorage();
  // }

  Future<void> loadUserFromStorage() async {
    print("AuthController: Loading user from storage...");
    final userJson = await storageService.getUser();
    if (userJson != null) {
      currentUser.value = json.decode(userJson);
      print("AuthController: User loaded successfully. Role: ${currentUser.value?['role']}");
    } else {
      print("AuthController: No user found in storage.");
    }
  }

  /// Saves user data to both the controller and secure storage
  Future<void> saveUser(Map<String, dynamic> userData) async {
    currentUser.value = userData;
    // Convert map to JSON string to store it
    await storageService.saveUser(json.encode(userData));
  }

  /// Loads user data from storage into the controller
  // Future<void> loadUserFromStorage() async {
  //   final userJson = await storageService.getUser();
  //   if (userJson != null) {
  //     currentUser.value = json.decode(userJson);
  //   }
  // }

  /// Clears user data from the controller and storage
  Future<void> clearUser() async {
    currentUser.value = null;
    await storageService.clearUser();
  }
}