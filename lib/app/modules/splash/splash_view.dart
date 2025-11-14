import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade600,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/logo.png", width: 250, height: 250,fit: BoxFit.fill,),
            //const Icon(Icons.agriculture, color: Colors.white, size: 80),
            const SizedBox(height: 40),
            Text(
              "Nexus Agriculture",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
             CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
