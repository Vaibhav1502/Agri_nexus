// app/data/models/subcategory_model.dart

class Subcategory {
  final int id;
  final String name;
  final String? slug;

  Subcategory({
    required this.id,
    required this.name,
    this.slug,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'],
    );
  }
}