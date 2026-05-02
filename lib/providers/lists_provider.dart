// lib/providers/lists_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shopping_list.dart';
import '../models/shopping_item.dart';
import '../dummy_data/dummy_data.dart';

class ListsNotifier extends StateNotifier<List<ShoppingList>> {
  ListsNotifier() : super(DummyData.cloneShoppingLists());

  void addList(ShoppingList list) {
    state = [...state, list];
  }

  void updateList(ShoppingList updatedList) {
    state = state.map((list) => list.id == updatedList.id ? updatedList : list).toList();
  }

  void deleteList(String listId) {
    state = state.where((list) => list.id != listId).toList();
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
  }

  void addItemToList(String listId, ShoppingItem newItem) {
    state = state.map((list) {
      if (list.id != listId) return list;
      return list.copyWith(
        items: [...list.items, newItem],
        isCompleted: false,
      );
    }).toList();
  }

  void removeItemFromList(String listId, String itemId) {
    state = state.map((list) {
      if (list.id != listId) return list;
      final updatedItems = list.items.where((item) => item.id != itemId).toList();
      return list.copyWith(items: updatedItems);
    }).toList();
  }

  /// Restore seed lists (UI demo reset).
  void resetToDummy() {
    state = DummyData.cloneShoppingLists();
  }
}

final listsProvider = StateNotifierProvider<ListsNotifier, List<ShoppingList>>((ref) {
  return ListsNotifier();
});