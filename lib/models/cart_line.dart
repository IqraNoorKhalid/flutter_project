// lib/models/cart_line.dart
import 'package:flutter/foundation.dart';

@immutable
class CartLine {
  const CartLine({
    required this.productId,
    required this.name,
    required this.category,
    required this.unitPrice,
    required this.quantity,
  });

  final String productId;
  final String name;
  final String category;
  final double unitPrice;
  final int quantity;

  double get lineTotal => unitPrice * quantity;

  CartLine copyWith({int? quantity}) {
    return CartLine(
      productId: productId,
      name: name,
      category: category,
      unitPrice: unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
