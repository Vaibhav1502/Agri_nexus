// app/controllers/global_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GlobalController extends GetxController {
  DateTime? lastBackPressed;

  // This function will handle the back press logic.
  bool canPop() {
    DateTime now = DateTime.now();
    // If the last back press was more than 2 seconds ago,
    // show a snackbar and don't exit.
    if (lastBackPressed == null || now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      Get.snackbar(
        '', // Title is empty
        'Press back again to exit',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        borderRadius: 25,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
      );
      return false; // Don't exit
    }
    // If the second press is within 2 seconds, exit the app.
    return true; // Exit
  }
}