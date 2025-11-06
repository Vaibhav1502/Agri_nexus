import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_controller.dart';

class OrderView extends StatelessWidget {
  final controller = Get.put(OrderController());

  OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
       // backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(
            child: Text(
              "You haven’t placed any orders yet 🛒",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.receipt_long, color: Colors.green),
                ),
                title: Text(
                  "Order #${order['id'] ?? 'N/A'}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status: ${order['status'] ?? 'Pending'}"),
                    Text("Total: ₹${order['total_amount'] ?? '0.00'}"),
                    Text("Date: ${order['created_at'] ?? ''}"),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () {
                    Get.toNamed('/order-detail', arguments: order['id']);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
