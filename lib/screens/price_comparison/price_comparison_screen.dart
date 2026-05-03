// lib/screens/price_comparison/price_comparison_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../providers/products_provider.dart';
import '../../models/product.dart';
import '../../widgets/price_comparison_card.dart';
import '../../widgets/product_photo.dart';
import '../../widgets/site_page_header.dart';
import '../../core/layout/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/utils/product_match.dart';

class PriceComparisonScreen extends ConsumerStatefulWidget {
  final String listId;

  const PriceComparisonScreen({super.key, required this.listId});

  @override
  ConsumerState<PriceComparisonScreen> createState() => _PriceComparisonScreenState();
}

class _PriceComparisonScreenState extends ConsumerState<PriceComparisonScreen> {
  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(listsProvider);
    final products = ref.watch(productsProvider);
    final shoppingList = lists.firstWhere((l) => l.id == widget.listId);

    final matched = matchedProductsForListItems(
      shoppingList.items.map((i) => i.name).toList(),
      products,
    );

    var effectiveId = _selectedProductId;
    if (effectiveId == null && matched.isNotEmpty) {
      effectiveId = matched.first.id;
    } else if (effectiveId != null && matched.every((p) => p.id != effectiveId)) {
      effectiveId = matched.isNotEmpty ? matched.first.id : null;
    }

    Product? effectiveProduct;
    if (effectiveId != null) {
      try {
        effectiveProduct = products.firstWhere((p) => p.id == effectiveId);
      } catch (_) {
        effectiveProduct = matched.isNotEmpty ? matched.first : null;
      }
    } else {
      effectiveProduct = null;
    }

    final scheme = Theme.of(context).colorScheme;

    if (effectiveProduct == null) {
      return Scaffold(
        backgroundColor: scheme.surfaceContainerLowest,
        body: _NoMatchesBody(
          listName: shoppingList.name,
          onBack: () => context.pop(),
        ),
      );
    }

    final product = effectiveProduct;
    final sortedPrices = [...product.storePrices]..sort((a, b) => a.price.compareTo(b.price));
    final gutter = AppLayout.pageGutter(context);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SitePageHeader(
              title: AppStrings.comparePrices,
              subtitle: shoppingList.name,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.md, gutter, AppSizes.sm),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
                  child: Material(
                    color: scheme.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            child: ProductPhoto(
                              product: product,
                              width: 88,
                              height: 88,
                              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                              iconSize: 36,
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: scheme.primaryContainer.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    product.category,
                                    style: TextStyle(
                                      color: scheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (matched.length > 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, AppSizes.sm, gutter, AppSizes.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From your list',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: matched.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final p = matched[index];
                          final selected = p.id == product.id;
                          return ChoiceChip(
                            label: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            selected: selected,
                            onSelected: (_) {
                              HapticFeedback.selectionClick();
                              setState(() => _selectedProductId = p.id);
                            },
                            showCheckmark: false,
                            selectedColor: scheme.primaryContainer,
                            labelStyle: TextStyle(
                              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 13,
                              color: selected ? scheme.primary : scheme.onSurface,
                            ),
                            side: BorderSide(
                              color: selected ? scheme.primary.withValues(alpha: 0.35) : scheme.outlineVariant,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                gutter,
                matched.length > 1 ? 0 : AppSizes.md,
                gutter,
                AppSizes.sm,
              ),
              child: Row(
                children: [
                  Icon(Icons.store_mall_directory_rounded, size: 20, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Store offers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    '${sortedPrices.length} stores',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final storePrice = sortedPrices[index];
                  final low = product.currentLowestPrice;
                  final isBest = storePrice.price == low;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.sm),
                    child: PriceComparisonCard(
                      storePrice: storePrice,
                      isBestDeal: isBest,
                      lowestPrice: low,
                    ),
                  );
                },
                childCount: sortedPrices.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.sm, gutter, AppSizes.xl),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppLayout.maxContentWidth),
                  child: _SavingsCard(
                    product: product,
                    onToggleTrack: () {
                      final wasTracked = product.isTracked;
                      ref.read(productsProvider.notifier).toggleTracking(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            wasTracked ? 'Removed from tracking' : AppStrings.productTracked,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsCard extends ConsumerWidget {
  const _SavingsCard({
    required this.product,
    required this.onToggleTrack,
  });

  final Product product;
  final VoidCallback onToggleTrack;

  double _savings(Product p) {
    if (p.storePrices.isEmpty) return 0;
    final hi = p.storePrices.map((sp) => sp.price).reduce((a, b) => a > b ? a : b);
    return hi - p.currentLowestPrice;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final tracked = ref.watch(
      productsProvider.select((list) {
        for (final p in list) {
          if (p.id == product.id) return p.isTracked;
        }
        return false;
      }),
    );

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            scheme.primaryContainer.withValues(alpha: 0.35),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${AppStrings.youSave} Rs. ${_savings(product).toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.success,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            '${AppStrings.byChoosing} ${product.bestStore}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onToggleTrack,
              style: FilledButton.styleFrom(
                backgroundColor: tracked ? scheme.error : scheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(tracked ? 'Stop tracking' : AppStrings.trackThisProduct),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoMatchesBody extends StatelessWidget {
  const _NoMatchesBody({
    required this.listName,
    required this.onBack,
  });

  final String listName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const Spacer(),
            Icon(Icons.inventory_2_outlined, size: 64, color: scheme.outline),
            const SizedBox(height: AppSizes.md),
            Text(
              'No catalog match yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Add items that match the shop catalog (e.g. “Milk 1L”, “Bread”) to compare live store prices for “$listName”.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            const Spacer(),
            FilledButton(
              onPressed: onBack,
              child: const Text('Back to list'),
            ),
          ],
        ),
      ),
    );
  }
}
