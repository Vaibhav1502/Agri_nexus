import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatelessWidget {
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/logo.png", width: 250, height: 250,fit: BoxFit.fill,),
            //const Icon(Icons.agriculture, color: Colors.white, size: 80),
            const SizedBox(height: 20),
            Text(
              "Nexus Agriculture",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
             CircularProgressIndicator(color: Colors.green.shade600),
          ],
        ),
      ),
    );
  }
}
