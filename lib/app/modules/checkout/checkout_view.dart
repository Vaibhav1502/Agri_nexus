// app/modules/checkout/checkout_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'checkout_controller.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CheckoutController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle("Contact Information"),
              const SizedBox(height: 16),
              Text("Full Name", style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: controller.nameController,
                style: const TextStyle(fontSize: 20),
                //decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
              ),
              const SizedBox(height: 12),
              Text("Email Address", style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: controller.emailController,
                style: const TextStyle(fontSize: 20),
                //decoration: const InputDecoration(labelText: "Email Address"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => !GetUtils.isEmail(value!) ? "Enter a valid email" : null,
              ),
              const SizedBox(height: 12),
              Text("Phone Number", style: TextStyle(fontSize: 17)),
              TextFormField(
                controller: controller.phoneController,
                style: const TextStyle(fontSize: 20),
               // decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Phone cannot be empty" : null,
              ),
              const Divider(height: 40),

              _buildSectionTitle("Billing Address"),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.billingAddressController,
                decoration: const InputDecoration(labelText: "Full Billing Address", alignLabelWithHint: true),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? "Billing address is required" : null,
              ),
              const Divider(height: 40),

              _buildSectionTitle("Shipping Address"),
              Obx(() => CheckboxListTile(
                    title: const Text("Shipping address is the same as billing address"),
                    value: controller.useSameAddress.value,
                    onChanged: (val) {
                      controller.useSameAddress.value = val ?? true;
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  )),
              const SizedBox(height: 16),
              Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.useSameAddress.value
                        ? const SizedBox.shrink() // Hide if checkbox is ticked
                        : TextFormField(
                            controller: controller.shippingAddressController,
                            decoration: const InputDecoration(labelText: "Full Shipping Address", alignLabelWithHint: true),
                            maxLines: 4,
                            validator: (value) {
                              // Only validate if the checkbox is unticked
                              if (!controller.useSameAddress.value && (value == null || value.isEmpty)) {
                                return "Shipping address is required";
                              }
                              return null;
                            },
                          ),
                  )),
              const Divider(height: 40),

              _buildSectionTitle("Additional Notes (Optional)"),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.notesController,
                decoration: const InputDecoration(labelText: "Notes for delivery", alignLabelWithHint: true),
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              
              Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: controller.placeOrder,
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text("Place Order"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}