// lib/widgets/product_photo.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../core/category_visual.dart';

/// Loads [Product.photoUrl] when set; otherwise shows category gradient + icon.
class ProductPhoto extends StatelessWidget {
  const ProductPhoto({
    super.key,
    required this.product,
    this.height,
    this.width,
    this.borderRadius,
    this.iconSize = 44,
  });

  final Product product;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final double iconSize;

  Widget _fallback(CategoryVisual vis, double w, double h) {
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: vis.colors.map((c) => c.withValues(alpha: 0.92)).toList(),
        ),
      ),
      child: Center(
        child: Icon(vis.icon, color: Colors.white.withValues(alpha: 0.92), size: iconSize),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vis = CategoryVisual.forCategory(product.category);
    final url = product.photoUrl;
    final r = borderRadius ?? BorderRadius.zero;

    if (url == null || url.isEmpty) {
      return LayoutBuilder(
        builder: (context, c) {
          final w = width ?? c.maxWidth;
          final h = height ?? c.maxHeight;
          return ClipRRect(
            borderRadius: r,
            child: _fallback(vis, w, h),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = width ?? constraints.maxWidth;
        final h = height ?? constraints.maxHeight;
        final dpr = MediaQuery.devicePixelRatioOf(context);
        final memW = (w * dpr).round().clamp(200, 1200);

        return ClipRRect(
          borderRadius: r,
          child: SizedBox(
            width: w,
            height: h,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              width: w,
              height: h,
              cacheWidth: memW,
              filterQuality: FilterQuality.medium,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    _fallback(vis, w, h),
                    ColoredBox(
                      color: Colors.black.withValues(alpha: 0.1),
                      child: const Center(
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
                  ],
                );
              },
              errorBuilder: (_, __, ___) => _fallback(vis, w, h),
            ),
          ),
        );
      },
    );
  }
}
