import 'package:agri_nexus_ht/app/controller/auth_controller.dart';
import 'package:agri_nexus_ht/app/data/models/subcategory_model.dart';
import 'package:get/get.dart';

class Product {
  final int id;
  final String name;
  final String? description;
  final String? shortDescription;
  final double price;
  final double originalPrice;
  final double salePrice;
  final double? dealerPrice; // 👈 ADDED
  final double? dealerSalePrice; // 👈 ADDED
  final String? image;
  final String? brand;
  final String? categoryName;
  final Subcategory? subcategory;

  final int discountPercentage;
  final List<Product> relatedProducts; // 👈 Added this
  final String? power_source;
  final int? stock_quantity;
  final String? warranty;
  final String? weight;
  final String? dimensions;

  // 👇 Smart getter to get the correct price based on user role
  double get displayPrice {
    final authController = Get.find<AuthController>();
    // This will print for every product card on the screen
  print("--- 💰 Pricing for product '${this.name}' ---");
  print("isApprovedDealer: ${authController.isApprovedDealer}");
  print("Dealer Sale Price: ${this.dealerSalePrice}");
  print("Regular Sale Price: ${this.salePrice}");
    if (authController.isApprovedDealer && dealerSalePrice != null && dealerSalePrice! > 0) {
       print("✅ Using DEALER price: ${this.dealerSalePrice}");
      return dealerSalePrice!;
    }
     print("❌ Using REGULAR price: ${this.salePrice}");
    return salePrice;
  }

  // 👇 Smart getter for the original price (useful for showing a strike-through price)
  double get displayOriginalPrice {
    final authController = Get.find<AuthController>();
     if (authController.isApprovedDealer && dealerPrice != null && dealerPrice! > 0) {
      return dealerPrice!;
    }
    return originalPrice;
  }

  Product({
    required this.id,
    required this.name,
    this.description,
    this.shortDescription,
    required this.price,
    required this.originalPrice,
    required this.salePrice,
    this.dealerPrice, // 👈 ADDED
    this.dealerSalePrice, // 👈 ADDED
    this.image,
    this.brand,
    this.categoryName,
    this.subcategory,
    required this.discountPercentage,
    this.relatedProducts = const [], // 👈 Prevent null errors
    this.power_source,
    this.stock_quantity,
    this.warranty,
    this.weight,
    this.dimensions
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      name: json["name"] ?? "",
      description: json["description"],
      power_source: json["power_source"],
      warranty: json["warranty"],
      weight: json["weight"],
      dimensions: json["dimensions"],
      stock_quantity: json["stock_quantity"],
      shortDescription: json["short_description"],
      price: (json["price"] ?? 0).toDouble(),
      originalPrice: (json["original_price"] ?? 0).toDouble(),
      salePrice: (json["sale_price"] ?? 0).toDouble(),
      dealerPrice: (json["dealer_price"] ?? 0).toDouble(), // 👈 ADDED
      dealerSalePrice: (json["dealer_sale_price"] ?? 0).toDouble(), // 👈 ADDED
      image: json["image"],
      brand: json["brand"],
      categoryName: json["category"]?["name"],
      subcategory: json["subcategory"] != null
          ? Subcategory.fromJson(json["subcategory"])
          : null,
      discountPercentage: json["discount_percentage"] ?? 0,
      relatedProducts: json["related_products"] != null
          ? (json["related_products"] as List)
              .map((e) => Product.fromJson(e))
              .toList()
          : [],
    );
  }
}
