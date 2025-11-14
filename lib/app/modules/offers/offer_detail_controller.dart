// app/modules/offers/offer_detail_controller.dart

import 'dart:convert';
import 'package:agri_nexus_ht/app/data/models/offer_model.dart'; // We can reuse our existing Offer model
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OfferDetailController extends GetxController {
  var isLoading = false.obs;
  var offer = Rxn<Offer>(); // Observable for a single Offer object

  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1/offers';

  /// Fetches details for a specific offer by its ID
  Future<void> fetchOfferDetail(int offerId) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$offerId'),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // The data for a single offer is not nested inside another 'data' key
        offer.value = Offer.fromJson(data['data']);
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to load offer details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}