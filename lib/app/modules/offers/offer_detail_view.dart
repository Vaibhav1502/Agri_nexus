// app/modules/offers/offer_detail_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/offer_model.dart';
import 'offer_detail_controller.dart';

class OfferDetailView extends StatelessWidget {
  const OfferDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OfferDetailController());
    final int offerId = Get.arguments; // Get the offer ID passed as an argument

    return GetBuilder<OfferDetailController>(
      initState: (_) => controller.fetchOfferDetail(offerId),
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Offer Details"),
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final offer = controller.offer.value;
            if (offer == null) {
              return const Center(child: Text("Offer details not found."));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Banner Image ---
                  if (offer.bannerImage != null)
                    Image.network(
                      offer.bannerImage!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.error, color: Colors.grey),
                      ),
                    ),
                  
                  // --- Main Content ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Discount Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            offer.discountString,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        if (offer.description != null)
                          Text(
                            offer.description!,
                            style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                          ),
                        
                        const Divider(height: 40),

                        // Validity Details
                        _buildInfoRow(
                          Icons.timer_outlined,
                          "Validity",
                          offer.validityString,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.info_outline,
                          "Offer Type",
                          offer.offerType?.capitalizeFirst ?? 'General',
                        ),

                        // We can add more details from the API if needed in the future
                        // For example, Terms & Conditions.
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  // Helper for consistent info rows
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}