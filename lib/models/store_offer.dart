// lib/models/store_offer.dart
class StoreOffer {
  final String id;
  final String storeName;
  final String productName;
  final double originalPrice;
  final double salePrice;
  final String category;
  final DateTime expiresAt;
  final int discountPercentage;

  StoreOffer({
    required this.id,
    required this.storeName,
    required this.productName,
    required this.originalPrice,
    required this.salePrice,
    required this.category,
    required this.expiresAt,
    required this.discountPercentage,
  });

  bool get isValid => expiresAt.isAfter(DateTime.now());
  String get formattedExpiry => _getExpiryText();

  String _getExpiryText() {
    final difference = expiresAt.difference(DateTime.now()).inDays;
    if (difference == 0) return 'Ends today';
    if (difference == 1) return 'Ends tomorrow';
    return 'Ends in $difference days';
  }
}