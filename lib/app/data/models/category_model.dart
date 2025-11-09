import 'package:agri_nexus_ht/app/data/models/subcategory_model.dart';

class Category {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? image;
  final int productsCount;
  final List<Subcategory> subcategories;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.image,
    required this.productsCount,
    this.subcategories = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    // 👇 --- 4. PARSE the list of subcategories --- 👇
    var subcategoriesList = <Subcategory>[];
    if (json['subcategories'] != null && json['subcategories'] is List) {
      subcategoriesList = (json['subcategories'] as List)
          .map((subJson) => Subcategory.fromJson(subJson))
          .toList();
    }
    // 👆 --- END OF PARSING --- 👆
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      image: json['image'],
      productsCount: json['products_count'] ?? 0,
      subcategories: subcategoriesList,
    );
  }
}
