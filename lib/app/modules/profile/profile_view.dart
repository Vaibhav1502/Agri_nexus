import 'package:agri_nexus_ht/app/modules/login/login_controller.dart';
import 'package:agri_nexus_ht/app/modules/profile/edit_profile_view.dart';
import 'package:agri_nexus_ht/app/modules/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final controller = Get.put(ProfileController());
  final loginController = Get.put(LoginController());
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchAndUpdateUserProfile();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        //backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.userProfile.isEmpty) {
          return const Center(child: Text("No profile data found"));
        }

        final user = controller.userProfile;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      user['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      user['email'] ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  const Divider(height: 30, thickness: 1),

                  _buildInfoRow("Phone", user['phone']),
                  _buildInfoRow("Role", user['role']),
                  _buildInfoRow("Business Name", user['business_name']),
                  _buildInfoRow("GST Number", user['gst_number']),
                  _buildInfoRow("Company Website", user['company_website']),
                  //_buildInfoRow("PAN Number", user['pan_number']),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => EditProfileView());
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit Profile"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        loginController.logoutUser();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value == null || value.toString().isEmpty
                  ? '—'
                  : value.toString(),
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
