import 'package:agri_nexus_ht/app/data/models/category_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;

  final String baseUrl = 'https://nexus.heuristictechpark.com/api/v1/categories';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          categories.value = (data['data'] as List)
              .map((e) => Category.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading(false);
    }
  }
}
