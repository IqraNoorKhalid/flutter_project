// lib/models/shopping_item.dart
class ShoppingItem {
  final String id;
  final String name;
  final double quantity;
  final String unit;
  bool isChecked;
  final double lowestPrice;
  final String bestStore;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.isChecked,
    required this.lowestPrice,
    required this.bestStore,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    double? quantity,
    String? unit,
    bool? isChecked,
    double? lowestPrice,
    String? bestStore,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isChecked: isChecked ?? this.isChecked,
      lowestPrice: lowestPrice ?? this.lowestPrice,
      bestStore: bestStore ?? this.bestStore,
    );
  }
}