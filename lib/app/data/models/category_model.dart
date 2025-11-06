class Category {
  final int id;
  final String name;
  final String? slug;
  final String? description;
  final String? image;
  final int productsCount;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.image,
    required this.productsCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'],
      description: json['description'],
      image: json['image'],
      productsCount: json['products_count'] ?? 0,
    );
  }
}
