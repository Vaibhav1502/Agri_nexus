// app/controllers/network_controller.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Start listening to connectivity changes as soon as the controller is initialized.
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Check initial status as well
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      isOnline.value = false;
      // Show a single, persistent snackbar when offline
      Get.rawSnackbar(
        messageText: const Text(
          'No Internet Connection',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        isDismissible: false,
        duration: const Duration(days: 1), // Make it "permanent"
        backgroundColor: Colors.red[400]!,
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 35),
        margin: EdgeInsets.zero,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      if (!isOnline.value) { // Only update if the status changed from offline to online
        isOnline.value = true;
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
        // Optional: show a "Back Online" message
        Get.rawSnackbar(
          messageText: const Text(
            'You are back online',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          isDismissible: true,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green[400]!,
          icon: const Icon(Icons.wifi, color: Colors.white, size: 35),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
        );
      }
    }
  }
}