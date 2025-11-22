import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_controller.dart';
import 'package:flutter/services.dart';

class RegisterView extends StatelessWidget {
  final controller = Get.put(RegisterController());
   final _formKey = GlobalKey<FormState>();
 
  //final role = "customer".obs;

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {

     final String role = Get.arguments as String? ?? 'customer'; 
     final bool isDealer = role == 'dealer'; // Helper boolean
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Text(
                "Green Leaf",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
             const SizedBox(height: 8),
              Text(
                "Create Your ${role.capitalizeFirst} Account", // Dynamic title
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 30),
             
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  // Use SingleChildScrollView here so the form scrolls inside the white box
                  child: SingleChildScrollView( 
                    child: Form(
                      key: _formKey,
                      child: Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // --- BASIC USER DETAILS ---
                            TextFormField(
                              controller: controller.nameController,
                              decoration: const InputDecoration(
                                labelText: "Full Name *",
                                hintText: "Full Name",
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your full name.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: controller.emailController,
                              decoration: const InputDecoration(
                                labelText: "Email Address *",
                                hintText: "Email Address",
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || !GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: controller.phoneController,
                              decoration: const InputDecoration(
                                labelText: "Phone Number *",
                                hintText: "Phone Number",
                                prefixIcon: Icon(Icons.phone_outlined),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.length != 10) {
                                  return 'Please enter a valid 10-digit phone number.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: controller.passwordController,
                              obscureText: controller.isPasswordHidden.value,
                              decoration: InputDecoration(
                                labelText: "Password *",
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordHidden.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    controller.togglePasswordVisibility();
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                            ),

                            // 👇 --- DEALER SPECIFIC BUSINESS FIELDS --- 👇
                            // These fields only show up if the user selected "Dealer"
                            if (isDealer) ...[
                              const SizedBox(height: 25),
                              const Divider(color: Colors.grey),
                              const SizedBox(height: 10),
                              const Text(
                                "Business Details",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              
                              TextFormField(
                                controller: controller.businessNameController,
                                decoration: const InputDecoration(
                                  labelText: "Business Name *",
                                  prefixIcon: Icon(Icons.business),
                                ),
                                validator: (value) {
                                  // Only validate if role is dealer
                                  if (isDealer && (value == null || value.trim().isEmpty)) {
                                    return 'Business name is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: controller.gstController,
                                decoration: const InputDecoration(
                                  labelText: "GST Number *",
                                  prefixIcon: Icon(Icons.receipt_long),
                                ),
                                textCapitalization: TextCapitalization.characters,
                                validator: (value) {
                                  if (isDealer) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'GST number is required.';
                                    }
                                    // Basic GST Regex
                                    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                                    if (!gstRegex.hasMatch(value.toUpperCase())) {
                                      return 'Enter a valid 15-char GSTIN.';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: controller.addressController,
                                decoration: const InputDecoration(
                                  labelText: "Business Address *",
                                  prefixIcon: Icon(Icons.location_on_outlined),
                                ),
                                maxLines: 2,
                                validator: (value) {
                                  if (isDealer && (value == null || value.trim().isEmpty)) {
                                    return 'Address is required.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              // Website is optional
                              TextFormField(
                                controller: controller.websiteController,
                                decoration: const InputDecoration(
                                  labelText: "Website",
                                  prefixIcon: Icon(Icons.language),
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
  controller: controller.descriptionController,
  decoration: const InputDecoration(
    labelText: "Business Description",
    prefixIcon: Icon(Icons.description_outlined),
    alignLabelWithHint: true, // Keeps label at top for multiline
  ),
  maxLines: 3, // Allow multiple lines
),
const SizedBox(height: 15),
                              
                              // Terms Checkbox for Dealers
                              CheckboxListTile(
                                title: const Text("I accept the terms and conditions"),
                                value: controller.termsAccepted.value,
                                onChanged: (val) => controller.termsAccepted.value = val ?? false,
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                            // 👆 --- END OF DEALER FIELDS --- 👆

                            const SizedBox(height: 30),
                            
                            // --- SUBMIT BUTTON ---
                            controller.isLoading.value
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.registerUser(role: role);
                                      } else {
                                        Get.snackbar(
                                          "Invalid Input",
                                          "Please correct the errors in the form.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.redAccent,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      // backgroundColor: Colors.green,
                                    ),
                                    child: Text(
                                      "Register",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 15),
                            TextButton(
                              onPressed: () => Get.offAllNamed(AppRoutes.login),
                              child: Text(
                                "Already have an account? Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            // Add some bottom padding for scrolling
                            const SizedBox(height: 40),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}