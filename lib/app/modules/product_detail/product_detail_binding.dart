import 'package:agri_nexus_ht/app/modules/product_detail/product_detail_controller.dart';
import 'package:get/get.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    print("ProductDetailBinding INITIALIZED");
    Get.lazyPut<ProductDetailController>(() => ProductDetailController());
  }
}