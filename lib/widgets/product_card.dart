// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import 'product_photo.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onTrackToggle;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onTrackToggle,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: ProductPhoto(
                        product: product,
                        width: 64,
                        height: 64,
                        borderRadius: BorderRadius.circular(12),
                        iconSize: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.category,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'From Rs. ${product.currentLowestPrice.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: onTrackToggle,
                    style: IconButton.styleFrom(
                      backgroundColor: product.isTracked
                          ? AppColors.error.withValues(alpha: 0.12)
                          : scheme.surfaceContainerHighest,
                    ),
                    icon: Icon(
                      product.isTracked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: product.isTracked ? AppColors.error : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
