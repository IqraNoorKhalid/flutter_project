// lib/providers/deals_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/store_offer.dart';
import '../dummy_data/dummy_data.dart';

class DealsNotifier extends StateNotifier<List<StoreOffer>> {
  DealsNotifier() : super(DummyData.deals);

  List<StoreOffer> filterByCategory(String? category) {
    if (category == null || category == 'All') {
      return state;
    }
    return state.where((deal) => deal.category == category).toList();
  }
}

final dealsProvider = StateNotifierProvider<DealsNotifier, List<StoreOffer>>((ref) {
  return DealsNotifier();
});