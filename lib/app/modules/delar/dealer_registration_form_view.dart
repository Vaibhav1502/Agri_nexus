// app/modules/dealer/dealer_registration_form_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dealer_registration_form_controller.dart';

class DealerRegistrationFormView extends StatelessWidget {
  final controller = Get.put(DealerRegistrationFormController());

  DealerRegistrationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dealer Business Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Complete Your Profile",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please provide your business details to get access to dealer pricing.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: controller.businessNameController,
                decoration: const InputDecoration(labelText: "Business Name"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.gstController,
                decoration: const InputDecoration(labelText: "GST Number"),
                 // 👇 ADD VALIDATOR
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'GST number is required.';
          }
          if (value.length != 15) {
            return 'GST number must be 15 characters long.';
          }
          return null; // Return null if the input is valid
        },
      
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.addressController,
                decoration: const InputDecoration(labelText: "Business Address"),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.websiteController,
                decoration: const InputDecoration(labelText: "Company Website"),
                // 👇 ADD VALIDATOR FOR URL
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            // A simple check for a valid-looking URL
            if (!GetUtils.isURL(value)) {
              return 'Please enter a valid URL (e.g., https://example.com)';
            }
          }
          return null;
        },
      
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: "Business Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Obx(() => CheckboxListTile(
                title: const Text("I accept the terms and conditions"),
                value: controller.termsAccepted.value,
                onChanged: (val) {
                  controller.termsAccepted.value = val ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
              )),
              const SizedBox(height: 24),
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: controller.submitRegistration,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Submit for Approval"),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}