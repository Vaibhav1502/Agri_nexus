// app/modules/home/widgets/add_to_cart_button.dart

import 'package:agri_nexus_ht/app/modules/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddToCartButton extends StatelessWidget {
  final int productId;
  // Pass the controller so we don't have to find it every time
  final CartController cartController; 

  const AddToCartButton({
    super.key,
    required this.productId,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. Get current quantity
      final int quantity = cartController.getProductQuantity(productId);

      // 2. If quantity is 0, show the standard "Add to Cart" button
      if (quantity == 0) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              cartController.addToCart(productId);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text("Add to Cart", style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
        );
      }

      // 3. If quantity > 0, show the Increment/Decrement Row
      return Container(
        height: 40, // Fixed height to match button
        decoration: BoxDecoration(
          color: Colors.green.shade50, // Light green background
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // --- Minus Button ---
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.green, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40),
              onPressed: () {
                if (quantity > 1) {
                  cartController.updateCartItem(productId, quantity - 1);
                } else {
                  // If quantity is 1, removing it removes the item
                  cartController.removeFromCart(productId);
                }
              },
            ),

            // --- Quantity Text ---
            Text(
              "$quantity",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            // --- Plus Button ---
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40),
              onPressed: () {
                cartController.updateCartItem(productId, quantity + 1);
              },
            ),
          ],
        ),
      );
    });
  }
}