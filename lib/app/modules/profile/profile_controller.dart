import 'dart:convert';
import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ProfileController extends GetxController {
  final storageService = StorageService();
  final authController = Get.find<AuthController>();

  var isLoading = false.obs;
  
  // 👇 --- THIS IS THE FIX --- 👇
  // Explicitly declare the type of the observable Map.
  var userProfile = RxMap<String, dynamic>({});
  // 👆 --- END OF FIX --- 👆

  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1';

  // This method will now work without any type errors.
  Future<void> fetchAndUpdateUserProfile() async {
    isLoading.value = true;
    final token = await storageService.getToken();
  
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // The cast `as Map<String, dynamic>` is good practice for safety
        final userData = data['data']['user'] as Map<String, dynamic>? ?? {};
        userProfile.value = userData;

        // Now, this call is perfectly type-safe and will work.
        await authController.saveUser(userData);
        print("✅ User profile refreshed and saved globally.");

      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while fetching profile');
    } finally {
      isLoading.value = false;
    }
  }

  // Renamed method for clarity
  Future<void> fetchUserProfileForView() async {
      await fetchAndUpdateUserProfile();
  }

  /// ✏️ Update Profile
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final token = await storageService.getToken();
    isLoading.value = true;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar('Success', data['message']);
        userProfile.value = data['data']['user'];
      } else {
        Get.snackbar('Error', data['message'] ?? 'Profile update failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong while updating profile');
    } finally {
      isLoading.value = false;
    }
  }

  
}

