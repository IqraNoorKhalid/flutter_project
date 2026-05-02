// lib/models/shopping_list.dart
import 'shopping_item.dart';

class ShoppingList {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<String> tags;
  final bool isCompleted;
  final List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.tags,
    required this.isCompleted,
    required this.items,
  });

  double get totalEstimatedCost {
    return items.fold(0, (sum, item) => sum + (item.lowestPrice * item.quantity));
  }

  int get completedItemsCount {
    return items.where((item) => item.isChecked).length;
  }

  double get completionPercentage {
    if (items.isEmpty) return 0;
    return completedItemsCount / items.length;
  }

  ShoppingList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<String>? tags,
    bool? isCompleted,
    List<ShoppingItem>? items,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      isCompleted: isCompleted ?? this.isCompleted,
      items: items ?? this.items,
    );
  }
}