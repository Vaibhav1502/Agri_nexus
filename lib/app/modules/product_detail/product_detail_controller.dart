import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/providers/product_detail_provider.dart';

class ProductDetailController extends GetxController {
  final _provider = ProductDetailProvider();
  final authController = Get.find<AuthController>(); // 👈 GET an instance
  var product = Rxn<Product>();
  var isLoading = false.obs;
   var selectedImage = ''.obs;
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
}
