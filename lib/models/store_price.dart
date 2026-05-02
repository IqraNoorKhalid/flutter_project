// lib/models/store_price.dart
class StorePrice {
  final String storeName;
  final double price;
  final DateTime lastUpdated;

  StorePrice({
    required this.storeName,
    required this.price,
    required this.lastUpdated,
  });
}