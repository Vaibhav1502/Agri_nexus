import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_controller.dart';
import 'package:flutter/services.dart';

class RegisterView extends StatelessWidget {
  final controller = Get.put(RegisterController());
   final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  //final role = "customer".obs;

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {

     final String role = Get.arguments as String? ?? 'customer'; 
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
              Text(
                "Create Your Account",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                  child: Obx(() {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                               labelText: "Full Name *",
                              hintText: "Full Name",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name.';
                              }
                              return null; // Return null if the input is valid
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: emailController,
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
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                     labelText: "Phone Number *",
                                    hintText: "Phone Number",
                                    prefixIcon: Icon(Icons.phone_outlined),
                                    counterText: "", // Hide the default character counter
                                  ),
                                   
                            validator: (value) {
                              if (value == null || value.length != 10) {
                                return 'Please enter a valid 10-digit phone number.';
                              }
                              return null;
                            },
                                  // Set keyboard type to phone for a better user experience
                                  keyboardType: TextInputType.phone,
                                  // Enforce a 10-character limit
                                  maxLength: 10,
                                  // Allow only digits to be entered
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                ),
                          // TextField(
                          //   controller: phoneController,
                          //   decoration: const InputDecoration(
                          //     hintText: "Phone Number",
                          //     prefixIcon: Icon(Icons.phone_outlined),
                          //   ),
                          // ),
                          const SizedBox(height: 15),
                           TextFormField(
                                  controller: passwordController,
                                  // Bind obscureText to the controller's state
                                  obscureText: controller.isPasswordHidden.value,
                                  decoration: InputDecoration(
                                    labelText: "Password *",
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    // Add the show/hide toggle icon
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
                          // TextField(
                          //   controller: passwordController,
                          //   obscureText: true,
                          //   decoration: const InputDecoration(
                          //     hintText: "Password",
                          //     prefixIcon: Icon(Icons.lock_outline),
                          //   ),
                          // ),
                          const SizedBox(height: 15),
                          // DropdownButtonFormField<String>(
                          //   value: role.value,
                          //   items: const [
                          //     DropdownMenuItem(
                          //       value: "customer",
                          //       child: Text("Customer"),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: "dealer",
                          //       child: Text("Dealer"),
                          //     ),
                          //   ],
                          //   onChanged: (val) => role.value = val!,
                          //   decoration: const InputDecoration(
                          //     prefixIcon: Icon(Icons.person_pin_circle_outlined),
                          //     hintText: "Select Role",
                          //   ),
                          // ),
                          const SizedBox(height: 30),
                          controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                    controller.registerUser(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                      role: role,
                                      //role: role.value,
                                    );
                                    }else{
                                       Get.snackbar(
                                        "",
                                        "Please fill out all the fields",
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    }
                                  },
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
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
