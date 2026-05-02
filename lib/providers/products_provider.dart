// lib/providers/products_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../dummy_data/dummy_data.dart';

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super(DummyData.cloneProducts());

  void toggleTracking(String productId) {
    state = state.map((product) {
      if (product.id != productId) return product;
      return product.copyWith(isTracked: !product.isTracked);
    }).toList();
  }

  List<Product> getTrackedProducts() {
    return state.where((product) => product.isTracked).toList();
  }

  /// Restore seed products and tracking flags (UI demo reset).
  void resetToDummy() {
    state = DummyData.cloneProducts();
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});

final trackedProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  return products.where((p) => p.isTracked).toList();
});