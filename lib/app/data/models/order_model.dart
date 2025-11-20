// app/data/models/order_model.dart

import 'package:intl/intl.dart'; // Add `intl` package to pubspec.yaml if you haven't

class Order {
  final String orderNumber;
  final double totalAmount;
  final String orderStatus;
  final DateTime createdAt;
  final List<OrderItem> items;

  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String billingAddress;
  final String shippingAddress;
  final double subtotal;
  final double taxAmount;
  final double shippingAmount;
  final String? notes;
 
  


  Order({
    required this.orderNumber,
    required this.totalAmount,
    required this.orderStatus,
    required this.createdAt,
    required this.items,

    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.billingAddress,
    required this.shippingAddress,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingAmount,
    this.notes,
   
    
  });

  // 👇 --- THIS IS THE NEW, SIMPLIFIED LOGIC --- 👇
  
  /// Calculates the total discount amount for the order by summing item discounts.
  double get totalDiscount {
    if (items.isEmpty) return 0.0;
    // Sum the `discount_amount` from each item in the order.
    return items.fold(0.0, (sum, item) => sum + item.discountAmount);
  }

  /// Calculates the total original price before any discounts.
  double get originalSubtotal {
    // It's simply the final subtotal plus the total discount.
    return subtotal + totalDiscount;
  }
  
  // 👆 --- END OF NEW LOGIC --- 👆

  // A helper getter to format the date nicely
  String get formattedDate {
    // 1. Get the DateTime object.
    final dateTime = createdAt;
    
    // 2. Convert it from UTC to the device's local time zone.
    final localDateTime = dateTime.toLocal();
    
    // 3. Format the local time for display.
    return DateFormat('MMM dd, yyyy - hh:mm a').format(localDateTime);
  }

  // A helper getter to get the first product image for the list view
  String? get firstItemImage {
    if (items.isNotEmpty) {
      return items.first.image;
    }
    return null;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = <OrderItem>[];
    if (json['items'] != null) {
      itemsList = (json['items'] as List)
          .map((itemJson) => OrderItem.fromJson(itemJson))
          .toList();
    }

     // Helper to safely extract address string
    String _getAddress(dynamic addressData) {
      if (addressData is Map && addressData.containsKey('address')) {
        return addressData['address'];
      }
      return 'N/A';
    }

    return Order(
      orderNumber: json['order_number'] ?? 'N/A',
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      orderStatus: json['order_status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      items: itemsList,

      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      billingAddress: _getAddress(json['billing_address']),
      shippingAddress: _getAddress(json['shipping_address']),
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0.0).toDouble(),
      shippingAmount: (json['shipping_amount'] ?? 0.0).toDouble(),
      notes: json['notes'],
      

    );
  }
}

class OrderItem {
  final String productName;
  final String? image;
   final int quantity;
  final double price;
   final double? originalPrice; // The price before discount
  final double discountAmount; // The amount saved on this item
  final double total;
   final String? offerTitle;

  OrderItem({required this.productName, this.image,required this.quantity, required this.price,required this.total,this.originalPrice,required this.discountAmount,this.offerTitle,});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['product_name'] ?? 'Unknown Product',
      image: json['image'],
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      // Use original_price if it exists, otherwise fall back to price
      originalPrice: (json['original_price'] ?? json['price'] ?? 0.0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0.0).toDouble(), // 👈 PARSE this
      total: (json['total'] ?? 0.0).toDouble(),
      offerTitle: json['offer']?['title'], // 👈 PARSE the nested offer title
    );
  }
}