// app/modules/role_selection/role_selection_controller.dart

import 'package:get/get.dart';

class RoleSelectionController extends GetxController {
  // Observables to control the animation states
  var animate = false.obs;

  @override
  void onReady() {
    super.onReady();
    // Start the animations after a short delay once the screen is ready
    Future.delayed(const Duration(milliseconds: 300), () {
      animate.value = true;
    });
  }
}