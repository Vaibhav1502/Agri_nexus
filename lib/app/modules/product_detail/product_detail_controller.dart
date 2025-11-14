import 'dart:convert';

import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/data/models/offer_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/models/product_model.dart';
import '../../data/providers/product_detail_provider.dart';

class ProductDetailController extends GetxController {
  final _provider = ProductDetailProvider();
  final authController = Get.find<AuthController>(); // 👈 GET an instance
  var product = Rxn<Product>();
  var isLoading = false.obs;
   var selectedImage = ''.obs;
    var productOffers = <Offer>[].obs;
   int? _currentProductId; // 👈 Store the product ID

    @override
  void onInit() {
    super.onInit();
    // 👇 ADD LISTENER
    // If the user changes, and we have a product loaded, reload it.
    ever(authController.currentUser, (_) {
      if (_currentProductId != null) {
        loadProduct(_currentProductId!);
      }
    });
  }


  Future<void> loadProduct(int id) async {
     _currentProductId = id; // 👈 Store the ID
    print("🚀 Fetching product detail for ID: $id...");
    try {
      isLoading.value = true;
      product.value = await _provider.fetchProductDetail(id);
       if (product.value != null) {
        selectedImage.value = product.value!.image ?? '';
        fetchOffersForProduct(id);
      }
       print("✅ Product detail fetched. Dealer price: ${product.value?.dealerSalePrice}");
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product: $e');
    } finally {
      isLoading.value = false;
    }
  }
   void changeImage(String imageUrl) {
    selectedImage.value = imageUrl;
  }

   Future<void> fetchOffersForProduct(int productId) async {
    try {
      print("🚀 Fetching offers for product ID: $productId");
      final url = Uri.parse("https://nexus.heuristictechpark.com/api/v1/offers/product/$productId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          final List offerData = data['data'];
          productOffers.value = offerData
              .map((json) => Offer.fromJson(json))
              .where((offer) => offer.isValid) // Only show valid offers
              .toList();
          print("✅ Found ${productOffers.length} offers for this product.");
        }
      }
    } catch (e) {
      // Silently fail is fine for offers, as they are supplementary info
      print("Error fetching offers for product: $e");
    }
  }
}
