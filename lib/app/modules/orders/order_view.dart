// app/modules/orders/order_view.dart

import 'package:agri_nexus_ht/app/modules/orders/widgets/order_tracker.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'order_controller.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put() here to ensure the controller is initialized for this view
    final controller = Get.put(OrderController());

    return GetBuilder<OrderController>(
      // 3. The `initState` property is called exactly once when this widget is
      //    first created and placed on the screen. This is the perfect place
      //    to trigger our data fetch.
      initState: (_) {
        print("OrderView is now visible. Triggering fetchOrders().");
        controller.fetchOrders();
      },

    builder: (ctrl) {
      return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "You haven’t placed any orders yet",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.orders.length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              // 👇 --- REBUILT CARD UI USING LISTTILE --- 👇
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        // --- LEADING: Image ---
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            order.firstItemImage ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                            ),
                          ),
                        ),

                        // --- TITLE: Order Number ---
                        title: Text(
                          "Order :- ${order.orderNumber}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        // --- SUBTITLE: All other details ---
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Total: ₹${order.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Placed on: ${order.formattedDate}",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                            const Divider(height: 24),

                      // 👇 --- 2. REPLACE THE STATUS CHIP WITH THE TRACKER --- 👇
                      // If the order is cancelled, show a simple text message
                      if (order.orderStatus.toLowerCase() == 'cancelled')
                        const Text(
                          "This order has been cancelled.",
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      else
                        // Otherwise, show the tracker
                        OrderTracker(currentStatus: order.orderStatus),
                      // 👆 --- END OF REPLACEMENT --- 👆
                            // const SizedBox(height: 4),
                            // // Status Chip
                            // Container(
                            //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            //   decoration: BoxDecoration(
                            //     color: _getStatusColor(order.orderStatus).withOpacity(0.1),
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: Text(
                            //     order.orderStatus.capitalizeFirst ?? order.orderStatus,
                            //     style: TextStyle(
                            //       color: _getStatusColor(order.orderStatus),
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 12,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),

                        // --- TRAILING: Details Button ---
                        //trailing: const Icon(Icons.chevron_right,size: 13,),
                        onTap: () {
                           Get.toNamed('/order-detail', arguments: order.orderNumber);
                          // TODO: Navigate to Order Detail View
                          // Get.toNamed('/order-detail', arguments: order.orderNumber);
                         // Get.snackbar("Coming Soon", "Order detail page is under development.");
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        );
      },
    );
  }

  // Helper function to return a color based on order status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'shipped':
      case 'delivered':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      case 'inquiry':
      default:
        return Colors.orange;
    }
  }
}