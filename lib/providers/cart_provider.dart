// lib/providers/cart_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_line.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartLine>> {
  CartNotifier() : super(const []);

  void addProduct(Product product) {
    final price = product.currentLowestPrice;
    final idx = state.indexWhere((l) => l.productId == product.id);
    if (idx >= 0) {
      final line = state[idx];
      state = [
        ...state.sublist(0, idx),
        line.copyWith(quantity: line.quantity + 1),
        ...state.sublist(idx + 1),
      ];
      return;
    }
    state = [
      ...state,
      CartLine(
        productId: product.id,
        name: product.name,
        category: product.category,
        unitPrice: price,
        quantity: 1,
      ),
    ];
  }

  void decrementOrRemove(String productId) {
    final idx = state.indexWhere((l) => l.productId == productId);
    if (idx < 0) return;
    final line = state[idx];
    if (line.quantity <= 1) {
      state = [
        ...state.sublist(0, idx),
        ...state.sublist(idx + 1),
      ];
      return;
    }
    state = [
      ...state.sublist(0, idx),
      line.copyWith(quantity: line.quantity - 1),
      ...state.sublist(idx + 1),
    ];
  }

  void removeLine(String productId) {
    state = state.where((l) => l.productId != productId).toList();
  }

  void clear() {
    state = const [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartLine>>((ref) {
  return CartNotifier();
});

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold(0, (sum, line) => sum + line.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold(0.0, (sum, line) => sum + line.lineTotal);
});
