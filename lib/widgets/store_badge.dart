// lib/widgets/store_badge.dart
import 'package:flutter/material.dart';
import '../core/constants/app_sizes.dart';

class StoreBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const StoreBadge({
    super.key,
    required this.text,
    this.color = const Color(0xFFE8F5E9),
    this.textColor = const Color(0xFF2E7D32),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: textColor.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSizes.fontSizeXs,
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),
    );
  }
}
