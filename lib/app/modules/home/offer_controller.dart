// app/modules/home/offer_controller.dart

import 'dart:convert';

import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/controller/network_controller.dart';
import 'package:agri_nexus_ht/app/data/models/offer_model.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:agri_nexus_ht/api_config.dart';

class OfferController extends GetxController {
  final networkController = Get.find<NetworkController>();
  final authController = Get.find<AuthController>();

  var isLoading = false.obs;
  var offers = <Offer>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(authController.currentUser, (_) => fetchOffers());
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    if (!networkController.isOnline.value) {
      print("Offline: Skipping fetchOffers().");
      return;
    }
    if (isLoading.value) return;

    try {
      isLoading(true);
      print("🚀 Fetching offers...");
       final token = await Get.find<StorageService>().getToken();

      final response = await http.get(Uri.parse('$baseUrl/offers'),
       headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          final List offerData = data['data'];
          List<Offer> allOffers = offerData
              .map((json) => Offer.fromJson(json))
              .where((offer) => offer.isValid)
              .toList();
          print("✅ Found ${offers.length} offers.");
           bool isDealer = authController.isApprovedDealer;

          if (isDealer) {
            // If the user is a dealer, only keep offers where `for_dealers` is true.
            offers.value = allOffers.where((offer) => offer.forDealers).toList();
            print("User is a dealer. Found ${offers.length} dealer-specific offers.");
          } else {
            // Otherwise (if they are a customer or not logged in),
            // only keep offers where `for_customers` is true.
            offers.value = allOffers.where((offer) => offer.forCustomers).toList();
            print("User is a customer. Found ${offers.length} customer-specific offers.");
          }
        }
      } else {
        // Silently fail, don't show a snackbar for offers unless it's a critical error
        print("Failed to load offers. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching offers: $e");
    } finally {
      isLoading(false);
    }
  }
}