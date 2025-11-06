import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/storage_service.dart';
import '../../routes/app_pages.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  final storageService = StorageService();

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    isLoading.value = true;

    final url = Uri.parse('https://nexus.heuristictechpark.com/api/v1/register');
    final body = {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": password,
      "role": role,
      "phone": phone,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        final token = data["data"]["token"];
        await storageService.saveToken(token);

        Get.snackbar("Success", "Registration Successful!");
        // 👇 Navigate to login screen
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.login);
        });
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
