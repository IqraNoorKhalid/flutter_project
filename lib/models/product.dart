// lib/models/product.dart
import 'price_point.dart';
import 'store_price.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  /// Network image for UI (Unsplash etc.). Falls back to category art if null or load fails.
  final String? photoUrl;
  bool isTracked;
  final List<PricePoint> priceHistory;
  final List<StorePrice> storePrices;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.photoUrl,
    required this.isTracked,
    required this.priceHistory,
    required this.storePrices,
  });

  double get currentLowestPrice {
    if (storePrices.isEmpty) return 0;
    return storePrices.map((sp) => sp.price).reduce((a, b) => a < b ? a : b);
  }

  String get bestStore {
    if (storePrices.isEmpty) return '';
    return storePrices.reduce((a, b) => a.price < b.price ? a : b).storeName;
  }

  double get priceChange {
    if (priceHistory.length < 2) return 0;
    final current = priceHistory.last.price;
    final previous = priceHistory[priceHistory.length - 2].price;
    return current - previous;
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    String? imageUrl,
    String? photoUrl,
    bool? isTracked,
    List<PricePoint>? priceHistory,
    List<StorePrice>? storePrices,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      photoUrl: photoUrl ?? this.photoUrl,
      isTracked: isTracked ?? this.isTracked,
      priceHistory: priceHistory ?? this.priceHistory,
      storePrices: storePrices ?? this.storePrices,
    );
  }
}