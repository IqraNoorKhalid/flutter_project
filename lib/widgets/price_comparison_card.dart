// lib/widgets/price_comparison_card.dart
import 'package:flutter/material.dart';
import '../models/store_price.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';

class PriceComparisonCard extends StatelessWidget {
  final StorePrice storePrice;
  final bool isBestDeal;
  final double lowestPrice;

  const PriceComparisonCard({
    super.key,
    required this.storePrice,
    required this.isBestDeal,
    required this.lowestPrice,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: isBestDeal ? AppColors.success.withValues(alpha: 0.08) : scheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isBestDeal ? AppColors.success.withValues(alpha: 0.45) : scheme.outlineVariant.withValues(alpha: 0.6),
          width: isBestDeal ? 1.5 : 1,
        ),
        boxShadow: isBestDeal
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(Icons.store_mall_directory_rounded, color: scheme.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          storePrice.storeName,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isBestDeal) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Best',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Updated ${_formatDate(storePrice.lastUpdated)}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs. ${storePrice.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isBestDeal ? AppColors.success : scheme.onSurface,
                      ),
                ),
                if (!isBestDeal && storePrice.price > lowestPrice)
                  Text(
                    '+Rs. ${(storePrice.price - lowestPrice).toStringAsFixed(0)} vs best',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    return '${difference.inMinutes}m ago';
  }
}
