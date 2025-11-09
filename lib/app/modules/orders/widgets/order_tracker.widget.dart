// app/modules/orders/widgets/order_tracker.widget.dart

import 'package:agri_nexus_ht/app/modules/orders/widgets/pulsating_dot_widget.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderTracker extends StatelessWidget {
  final String currentStatus;

  static const _processes = [
    'pending',
    'inquiry',
    'processing',
    'shipped',
    'delivered',
  ];

  const OrderTracker({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    if (currentStatus.toLowerCase() == 'cancelled') {
      return _buildCancelledStatus();
    }
    
    int activeIndex = _processes.indexOf(currentStatus.toLowerCase());
    if (activeIndex < 0) {
      activeIndex = _processes.indexOf('processing'); // Default to a safe step
    }

      // 👇 --- THIS IS THE FIX --- 👇
    // Determine if the entire process is complete.
    bool isComplete = currentStatus.toLowerCase() == 'delivered';
    // 👆 --- END OF FIX --- 👆


    List<StepperData> stepperData = List.generate(_processes.length, (index) {
      return StepperData(
        title: StepperText(
          _processes[index].capitalizeFirst!,
          textStyle: TextStyle(
            fontSize: 8, // Small font size is key to prevent overflow
            color: index > activeIndex ? Colors.grey : Colors.black87,
            fontWeight: index == activeIndex ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        iconWidget: _buildIcon(index, activeIndex,isComplete),
      );
    });

    return AnotherStepper(
      stepperList: stepperData,
      stepperDirection: Axis.horizontal,
      activeBarColor: Colors.green,
      inActiveBarColor: Colors.grey.shade300,
      
      // 👇 --- THIS IS THE FIX --- 👇
      // 1. Control the size of the icons and bars
      barThickness: 3,
      iconWidth: 25,
      iconHeight: 25,

      // 2. We remove the non-existent 'gap' property.
      // The space is now controlled by the width of the screen being divided by 5 steps.
      // Reducing the font size is the most important part of fitting the text.
      // 👆 --- END OF FIX --- 👆
    );
  }

 Widget _buildIcon(int index, int activeIndex, bool isComplete) {
   if (isComplete) {
      return Container(
        decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      );
    }

    // If the step is completed
    if (index < activeIndex) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 18),
      );
    } 
    // If the step is currently active
    else if (index == activeIndex) {
      // 2. Use the new PulsatingDotWidget
      return const PulsatingDotWidget();
    } 
    // If the step is inactive (yet to be reached)
    else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCancelledStatus() {
    // ... no changes needed here
    return Container(/* ... */);
  }
}