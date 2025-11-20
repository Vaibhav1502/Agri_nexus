import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../register/register_view.dart';
import 'login_controller.dart';

class LoginView extends StatelessWidget {
  final controller = Get.put(LoginController());
   final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
                "Welcome Back 👋",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to your Green Leaf account",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
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
                      )
                    ],
                  ),
                  child: Obx(() {
                    return Form(
                        key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
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
                              return 'Please enter a valid email.';
                            }
                            return null;
                          },
                          ),
                          const SizedBox(height: 20),
                           TextFormField(
                                  controller: passwordController,
                                  // 1. Bind obscureText to the controller's state
                                  obscureText: controller.isPasswordHidden.value,
                                  decoration: InputDecoration(
                                    labelText: "Password *",
                                    hintText: "Password",
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    // 2. Add a suffixIcon with a tappable icon
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Choose the icon based on the state
                                        controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        // 3. Call the toggle method on press
                                        controller.togglePasswordVisibility();
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          // Allows submitting from the keyboard
                          onFieldSubmitted: (_) => _performLogin(),
                                ),
                          // TextField(
                          //   controller: passwordController,
                          //   obscureText: true,
                          //   decoration: const InputDecoration(
                          //     hintText: "Password",
                          //     prefixIcon: Icon(Icons.lock_outline),
                          //   ),
                          // ),
                          const SizedBox(height: 30),
                          controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                 onPressed: _performLogin,
                                  // onPressed: () {
                                  //   controller.loginUser(
                                  //     email: emailController.text,
                                  //     password: passwordController.text,
                                  //   );
                                  // },
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () => Get.to(() => RegisterView()),
                            child: Text(
                              "Don’t have an account? Register",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey.shade700),
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
  // 👇 4. CREATE a helper method for the login action
  void _performLogin() {
    // Validate the form first
    if (_formKey.currentState!.validate()) {
      // If valid, call the controller
      controller.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } else {
      Get.snackbar(
        "",
        "Please check your email and password.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

