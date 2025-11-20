// app/modules/orders/order_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/order_model.dart';
import 'order_detail_controller.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderDetailController());
    final String orderNumber = Get.arguments; // Get the order number passed as an argument

    // Use a GetBuilder to trigger the fetch once when the view is created
    return GetBuilder<OrderDetailController>(
      initState: (_) => controller.fetchOrderDetail(orderNumber),
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Order #$orderNumber"),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final order = controller.order.value;
            if (order == null) {
              return const Center(child: Text("Order details not found."));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummaryCard(order),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Items Ordered"),
                  _buildOrderItemsList(order.items),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Price Details"),
                  _buildPriceDetailsCard(order),
                  const SizedBox(height: 20),
                  _buildSectionTitle("Shipping Information"),
                  _buildAddressCard(order),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // Helper Widgets for a cleaner build method

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildOrderSummaryCard(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow("Order Number:", order.orderNumber),
            _buildInfoRow("Order Date:", order.formattedDate),
            _buildInfoRow("Order Status:", order.orderStatus.capitalizeFirst ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsList(List<OrderItem> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.image ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
          ),
          title: Text(item.productName),
          subtitle: Text("Qty: ${item.quantity}  |  Price: ₹${item.price.toStringAsFixed(2)}"),
          trailing: Text(
            "₹${item.total.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Widget _buildPriceDetailsCard(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (order.totalDiscount > 0) ...[
            _buildPriceRow("Subtotal (Original)", order.originalSubtotal),
            _buildPriceRow("Discount", -order.totalDiscount),
          ],
            _buildPriceRow("Subtotal", order.subtotal),
            _buildPriceRow("Tax", order.taxAmount),
            _buildPriceRow("Shipping", order.shippingAmount),
            const Divider(height: 20),
            _buildPriceRow("Total", order.totalAmount, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Order order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Billing Address", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order.billingAddress),
            const Divider(height: 20),
            const Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(order.shippingAddress),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
  
  Widget _buildPriceRow(String title, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}