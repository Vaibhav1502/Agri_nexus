// app/modules/orders/widgets/pulsating_dot_widget.dart

import 'package:flutter/material.dart';

class PulsatingDotWidget extends StatefulWidget {
  const PulsatingDotWidget({super.key});

  @override
  _PulsatingDotWidgetState createState() => _PulsatingDotWidgetState();
}

class _PulsatingDotWidgetState extends State<PulsatingDotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The pulsating outer circle
          FadeTransition(
            opacity: _animation.drive(Tween(begin: 0.5, end: 0.0)),
            child: ScaleTransition(
              scale: _animation,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withOpacity(0.5),
                ),
              ),
            ),
          ),
          // The solid inner dot
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}