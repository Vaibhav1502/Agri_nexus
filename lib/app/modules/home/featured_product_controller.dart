import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/data/models/product_model.dart';
import 'package:agri_nexus_ht/app/data/providers/featured_product_provider.dart';
import 'package:get/get.dart';


class FeaturedProductController extends GetxController {
  final _provider = FeaturedProductProvider();
   final authController = Get.find<AuthController>(); // 👈 GET an instance
  var featuredProducts = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    // 👇 --- ADD THIS LISTENER --- 👇
    // This will automatically re-fetch featured products whenever the user logs in or out.
   // ever(authController.currentUser, (_) => fetchFeaturedProducts());
    fetchFeaturedProducts();
    super.onInit();
  }

  Future<void> fetchFeaturedProducts() async {
     print("🚀 Fetching FEATURED products..."); // Add a log for debugging
    try {
      isLoading.value = true;
      final products = await _provider.fetchFeaturedProducts();
      featuredProducts.assignAll(products);
      if (products.isNotEmpty) {
        print("✅ FEATURED products fetched. First product's dealer price: ${products.first.dealerSalePrice}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch featured products");
    } finally {
      isLoading.value = false;
    }
  }
}
