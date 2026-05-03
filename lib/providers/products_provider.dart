// lib/providers/products_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../dummy_data/dummy_data.dart';
import '../services/app_local_storage.dart';

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super(DummyData.cloneProducts()) {
    unawaited(_restoreTracking());
  }

  Future<void> _restoreTracking() async {
    final ids = await AppLocalStorage.loadTrackedProductIds();
    if (ids.isEmpty) return;
    state = state.map((p) => p.copyWith(isTracked: ids.contains(p.id))).toList();
  }

  void _persistTrackedIds() {
    final ids = state.where((p) => p.isTracked).map((p) => p.id).toSet();
    unawaited(AppLocalStorage.saveTrackedProductIds(ids));
  }

  void toggleTracking(String productId) {
    state = state.map((product) {
      if (product.id != productId) return product;
      return product.copyWith(isTracked: !product.isTracked);
    }).toList();
    _persistTrackedIds();
  }

  List<Product> getTrackedProducts() {
    return state.where((product) => product.isTracked).toList();
  }

  /// Restore seed products and tracking flags (UI demo reset).
  void resetToDummy() {
    state = DummyData.cloneProducts();
    _persistTrackedIds();
  }
}

final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) {
  return ProductsNotifier();
});

final trackedProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  return products.where((p) => p.isTracked).toList();
});