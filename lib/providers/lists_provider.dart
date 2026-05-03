// lib/providers/lists_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shopping_list.dart';
import '../models/shopping_item.dart';
import '../dummy_data/dummy_data.dart';
import '../services/app_local_storage.dart';

class ListsNotifier extends StateNotifier<List<ShoppingList>> {
  ListsNotifier() : super(DummyData.cloneShoppingLists()) {
    unawaited(_restore());
  }

  Future<void> _restore() async {
    final loaded = await AppLocalStorage.loadShoppingLists();
    if (loaded != null && loaded.isNotEmpty) {
      state = loaded;
    }
  }

  void _persist() {
    unawaited(AppLocalStorage.saveShoppingLists(state));
  }

  void addList(ShoppingList list) {
    state = [...state, list];
    _persist();
  }

  void updateList(ShoppingList updatedList) {
    state = state.map((list) => list.id == updatedList.id ? updatedList : list).toList();
    _persist();
  }

  void deleteList(String listId) {
    state = state.where((list) => list.id != listId).toList();
    _persist();
  }

  void toggleItemCheck(String listId, String itemId) {
    state = state.map((list) {
      if (list.id != listId) return list;

      final updatedItems = list.items.map((item) {
        if (item.id != itemId) return item;
        return item.copyWith(isChecked: !item.isChecked);
      }).toList();

      final allChecked = updatedItems.every((item) => item.isChecked);

      return list.copyWith(
        items: updatedItems,
        isCompleted: allChecked,
      );
    }).toList();
    _persist();
  }

  void addItemToList(String listId, ShoppingItem newItem) {
    state = state.map((list) {
      if (list.id != listId) return list;
      return list.copyWith(
        items: [...list.items, newItem],
        isCompleted: false,
      );
    }).toList();
    _persist();
  }

  void removeItemFromList(String listId, String itemId) {
    state = state.map((list) {
      if (list.id != listId) return list;
      final updatedItems = list.items.where((item) => item.id != itemId).toList();
      return list.copyWith(items: updatedItems);
    }).toList();
    _persist();
  }

  /// Restore seed lists (UI demo reset).
  void resetToDummy() {
    state = DummyData.cloneShoppingLists();
    _persist();
  }
}

final listsProvider = StateNotifierProvider<ListsNotifier, List<ShoppingList>>((ref) {
  return ListsNotifier();
});