// lib/core/category_visual.dart
import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

class CategoryVisual {
  const CategoryVisual({
    required this.icon,
    required this.colors,
  });

  final IconData icon;
  final List<Color> colors;

  static CategoryVisual forCategory(String category) {
    switch (category.toLowerCase()) {
      case 'dairy':
        return const CategoryVisual(
          icon: Icons.local_drink_rounded,
          colors: [Color(0xFF42A5F5), Color(0xFF1565C0)],
        );
      case 'bakery':
        return const CategoryVisual(
          icon: Icons.bakery_dining_rounded,
          colors: [Color(0xFFFFB74D), Color(0xFFE65100)],
        );
      case 'meat':
        return const CategoryVisual(
          icon: Icons.restaurant_rounded,
          colors: [Color(0xFFEF5350), Color(0xFFC62828)],
        );
      case 'grains':
        return const CategoryVisual(
          icon: Icons.grass_rounded,
          colors: [Color(0xFF8D6E63), Color(0xFF4E342E)],
        );
      case 'beverages':
        return const CategoryVisual(
          icon: Icons.local_cafe_rounded,
          colors: [Color(0xFF7E57C2), Color(0xFF4527A0)],
        );
      case 'essentials':
        return const CategoryVisual(
          icon: Icons.home_work_rounded,
          colors: [AppColors.accentMint, Color(0xFF00695C)],
        );
      default:
        return const CategoryVisual(
          icon: Icons.shopping_basket_rounded,
          colors: [AppColors.primaryLight, AppColors.primaryDark],
        );
    }
  }
}
