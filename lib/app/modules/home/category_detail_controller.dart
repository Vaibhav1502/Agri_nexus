import 'dart:collection';
import 'dart:convert';
import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/data/models/product_model.dart';
import 'package:agri_nexus_ht/app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class CategoryDetailController extends GetxController {
   final storageService = StorageService();
   final authController = Get.find<AuthController>();
  var isLoading = false.obs;
  var categoryName = ''.obs;
  var categoryDescription = ''.obs;
  var products = <Product>[].obs;

   var groupedProducts = <String, List<Product>>{}.obs;

   int? _currentCategoryId;

    @override
  void onInit() {
    super.onInit();
    // 👇 --- 4. ADD THE REACTIVE LISTENER --- 👇
    // This will automatically re-fetch the category details if the user's login status changes.
    ever(authController.currentUser, (_) {
      // Only refresh if we have a category ID to load
      if (_currentCategoryId != null) {
        print("Auth state changed. Refreshing category details for ID: $_currentCategoryId");
        fetchCategoryDetails(_currentCategoryId!);
      }
    });
  }

  Future<void> fetchCategoryDetails(int categoryId) async {

     // Store the ID so the listener can use it
    _currentCategoryId = categoryId; 
    
    // Prevent re-fetching if already loading for the same category
    if (isLoading.value) return; 

    try {
      isLoading(true);
        print("🚀 Fetching category details for ID: $categoryId");
      final token = await storageService.getToken();
      final response = await http.get(
        Uri.parse("https://nexus.heuristictechpark.com/api/v1/categories/$categoryId"),
         headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          final categoryData = data["data"]["category"];
          categoryName.value = categoryData["name"] ?? "";
          categoryDescription.value = categoryData["description"] ?? "";

          final productList = data["data"]["products"]["data"] as List;
          final allProducts = productList.map((e) => Product.fromJson(e)).toList();
          products.value = productList.map((e) => Product.fromJson(e)).toList();
          products.value = allProducts;

           // 👇 --- GROUP THE PRODUCTS BY SUBCATEGORY --- 👇
          final grouped = <String, List<Product>>{};
          for (var product in allProducts) {
            // Use subcategory name as the key, or a default key for products without one.
            String key = product.subcategory?.name ?? 'Other Products';
            if (!grouped.containsKey(key)) {
              grouped[key] = [];
            }
            grouped[key]!.add(product);
          }
          
          // Use a LinkedHashMap to preserve insertion order if desired
          groupedProducts.value = LinkedHashMap.from(grouped);
          if (products.isNotEmpty) {
             print("✅ Category details fetched. First product's dealer price: ${products.first.dealerSalePrice}");
          }
        }
      }
    } catch (e) {
      print("Error fetching category details: $e");
    } finally {
      isLoading(false);
    }
  }
}
