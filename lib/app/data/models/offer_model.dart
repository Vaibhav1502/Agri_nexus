// app/data/models/offer_model.dart



import 'package:intl/intl.dart';

class Offer {
  final int id;
  final String title;
  final String? description;
  final String? bannerImage; // Corrected field name
  final String? offerType;
  final String? discountType;
  final double discountValue;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isValid;
  final String? status;
   final bool forCustomers;
  final bool forDealers;

  Offer({
    required this.id,
    required this.title,
    this.description,
    this.bannerImage,
    this.offerType,
    this.discountType,
    required this.discountValue,
    this.startDate,
    this.endDate,
    required this.status,
    required this.isValid,
    required this.forCustomers, // Add to constructor
    required this.forDealers,  // Add to constructor
   
  });

  // Helper getter to create the formatted validity string
  String get validityString {
    if (startDate == null || endDate == null) {
      return 'N/A';
    }
    // Using a simpler format
    final start = DateFormat('MMM dd').format(startDate!);
    final end = DateFormat('MMM dd, yyyy').format(endDate!);
    return '$start - $end';
  }

  // Helper getter to create a formatted discount string
  String get discountString {
    if (discountType == 'percentage') {
      return '${discountValue.toStringAsFixed(0)}% OFF';
    } else if (discountType == 'fixed') {
      return '₹${discountValue.toStringAsFixed(0)} OFF';
    }
    return 'Special Deal';
  }

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'],
      title: json['title'] ?? 'Special Offer',
      description: json['description'],
      bannerImage: json['banner_image'], // Corrected field name
      offerType: json['offer_type'],
      discountType: json['discount_type'],
      discountValue: (json['discount_value'] ?? 0.0).toDouble(),
      startDate: json['start_date'] != null ? DateTime.tryParse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date']) : null,
      isValid: json['is_valid'] ?? false,
       forCustomers: json['for_customers'] ?? false,
      forDealers: json['for_dealers'] ?? false,
      status: json['status'],
    );
  }
}