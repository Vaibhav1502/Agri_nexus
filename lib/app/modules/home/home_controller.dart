import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/providers/product_provider.dart';

class HomeController extends GetxController {
  final _provider = ProductProvider();
   final authController = Get.find<AuthController>(); // 👈 GET INSTANCE
  var products = <Product>[].obs;
  var isLoading = false.obs;
  
  var selectedIndex = 0.obs;

  // 👇 For product search
  var searchController = TextEditingController();
  var isSearching = false.obs;

  @override
  void onInit() {
     // 👇 --- ADD THIS LISTENER --- 👇
    // This will automatically call fetchProducts whenever the user logs in or out.
    //ever(authController.currentUser, (_) => fetchProducts());
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    print("🚀 Fetching products..."); // Add a log to see when it runs
    try {
      isLoading.value = true;
      products.value = await _provider.fetchProducts();
       print("✅ Products fetched successfully. First product's dealer price: ${products.first.dealerSalePrice}");
    } catch (e) {
      Get.snackbar("Error", "Failed to load products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 🔍 Search products by keyword
  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      isSearching.value = false;
      fetchProducts(); // reload all products
      return;
    }

    try {
      isLoading.value = true;
      isSearching.value = true;
      products.value = await _provider.searchProducts(query);
    } catch (e) {
      Get.snackbar("Error", "Search failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

   // 🧹 Clear search and reload products
  void clearSearch() {
    isSearching.value = false;
    searchController.clear();
    fetchProducts();
  }

    // 👇 New: Change Bottom Navigation Tab
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

