class ProductModel {
  final int id;
  final String name;
  final String? description;
  final double? price;
  final String? image;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? ''),
      image: json['image'] ?? '',
    );
  }
}
