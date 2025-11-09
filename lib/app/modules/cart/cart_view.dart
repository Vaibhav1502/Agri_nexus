import 'package:agri_nexus_ht/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class CartView extends StatelessWidget {
  final controller = Get.put(CartController());

  CartView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchCart();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        //backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  final productId = item['product_id'];
                  final quantity = item['quantity'];

                  return Card(
                    
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () {
                        // Navigate to the product detail page, passing the product's ID
                        Get.toNamed('/product-detail', arguments: productId);
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['image'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      ),
                      title: Text(
                        item['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text("₹${item['price']}"),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  if (quantity > 1) {
                                    controller.updateCartItem(
                                      productId,
                                      quantity - 1,
                                    );
                                  }
                                },
                              ),
                              Text(
                                "$quantity",
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  controller.updateCartItem(
                                    productId,
                                    quantity + 1,
                                  );
                                },
                              ),
                            ],
                          ),
                          Text(
                            "Subtotal: ₹${item['subtotal']}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          controller.removeFromCart(item['product_id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom summary + Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _summaryRow("Subtotal", controller.subtotal.value),
                  _summaryRow("Tax", controller.taxAmount.value),
                  _summaryRow("Shipping", controller.shippingAmount.value),
                  const Divider(),
                  _summaryRow(
                    "Total",
                    controller.total.value,
                    isBold: true,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),

                  // ✅ Proceed to Checkout Button
                  ElevatedButton(
                    onPressed: () {
                       Get.toNamed(AppRoutes.checkout);
                      // TODO: Checkout flow
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Proceed to Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🧹 Clear Cart Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.delete_forever, color: Colors.white),
                    label: const Text(
                      "Clear Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Get.defaultDialog(
                        title: "Clear Cart",
                        middleText:
                            "Are you sure you want to remove all items from your cart?",
                        confirm: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            controller.clearCart();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text("Yes, Clear"),
                        ),
                        cancel: TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _summaryRow(
    String title,
    double value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              fontSize: 14,
            ),
          ),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              color: color ?? Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
