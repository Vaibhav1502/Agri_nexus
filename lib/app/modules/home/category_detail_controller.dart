import 'dart:convert';
import 'package:agri_nexus_ht/app/data/models/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class CategoryDetailController extends GetxController {
  var isLoading = false.obs;
  var categoryName = ''.obs;
  var categoryDescription = ''.obs;
  var products = <Product>[].obs;

  Future<void> fetchCategoryDetails(int categoryId) async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse("https://nexus.heuristictechpark.com/api/v1/categories/$categoryId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true) {
          final categoryData = data["data"]["category"];
          categoryName.value = categoryData["name"] ?? "";
          categoryDescription.value = categoryData["description"] ?? "";

          final productList = data["data"]["products"]["data"] as List;
          products.value = productList.map((e) => Product.fromJson(e)).toList();
        }
      }
    } catch (e) {
      print("Error fetching category details: $e");
    } finally {
      isLoading(false);
    }
  }
}
