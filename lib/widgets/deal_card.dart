// lib/widgets/deal_card.dart
import 'package:flutter/material.dart';
import '../models/store_offer.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import 'store_badge.dart';

class DealCard extends StatelessWidget {
  final StoreOffer deal;
  final VoidCallback onTap;
  /// Horizontal strip on home (fixed width). Use `false` for grids / full-width lists.
  final bool forCarousel;

  const DealCard({
    super.key,
    required this.deal,
    required this.onTap,
    this.forCarousel = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: forCarousel ? 260 : null,
        margin: EdgeInsets.only(
          right: forCarousel ? AppSizes.md : 0,
          bottom: forCarousel ? 0 : AppSizes.md,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg + 2),
          gradient: LinearGradient(
            colors: [
              AppColors.secondary.withValues(alpha: 0.45),
              AppColors.primary.withValues(alpha: 0.35),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(2),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StoreBadge(
                      text: deal.storeName,
                      color: AppColors.primary.withValues(alpha: 0.12),
                      textColor: AppColors.primary,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        '-${deal.discountPercentage}%',
                        style: const TextStyle(
                          color: AppColors.secondaryDark,
                          fontSize: AppSizes.fontSizeSm,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  deal.productName,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeLg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    Text(
                      'Rs. ${deal.originalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeMd,
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      'Rs. ${deal.salePrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeLg,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: AppSizes.iconSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.xs),
                    Text(
                      deal.formattedExpiry,
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeXs,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}