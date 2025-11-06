// app/modules/role_selection/role_selection_view.dart

import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'role_selection_controller.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoleSelectionController());
    final Color primaryGreen = Colors.green.shade800; // A deeper green for better contrast

    return Scaffold(
      body: Container(
        // 👇 --- NEW, MORE DYNAMIC GRADIENT --- 👇
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -1.2), // Start the gradient from the top-center
            radius: 1.5,
            colors: [
              Colors.teal.shade50,   // Lightest color at the top
              Colors.green.shade50,  // Mid color
              Colors.white,          // Fades to white at the bottom
            ],
          ),
        ),
        // Optional: For a more textured background, you can add an image pattern
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: SvgPicture.asset('assets/your_pattern.svg'), // You'd need an SVG asset
        //     fit: BoxFit.cover,
        //     opacity: 0.1,
        //   )
        // ),
        // 👆 --- END OF NEW GRADIENT --- 👆
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // --- Header Section ---
                Obx(
                  () => AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: controller.animate.value ? 1.0 : 0.0,
                    child: Column(
                      children: [
                        Text(
                          "Welcome to Green Leaf...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Georgia', // A more elegant font if available
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Choose Your Role",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(flex: 1),

                // --- Role Selection Cards in a Row ---
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        imagePath: 'assets/dealer.jpg',
                        onTap: () => Get.toNamed(AppRoutes.register, arguments: 'dealer'),
                        isAnimated: controller.animate,
                        delay: 600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRoleCard(
                        imagePath: 'assets/customer.jpg',
                        onTap: () => Get.toNamed(AppRoutes.register, arguments: 'customer'),
                        isAnimated: controller.animate,
                        delay: 800,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(flex: 2),

                // --- Login Button ---
                Obx(
                  () => AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: controller.animate.value ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.black54, fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.login),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: primaryGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build a card with the new images and theme
  Widget _buildRoleCard({
    required String imagePath,
    required VoidCallback onTap,
    required RxBool isAnimated,
    required int delay,
  }) {
    return Obx(
      () => AnimatedSlide(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        offset: isAnimated.value ? Offset.zero : const Offset(0, 0.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: isAnimated.value ? 1.0 : 0.0,
          child: GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 8, // Slightly more pronounced shadow
              shadowColor: Colors.green.withOpacity(0.2), // Themed shadow color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAlias, // Ensures image respects the border radius
              child: Image.asset(
                imagePath,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 150, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}