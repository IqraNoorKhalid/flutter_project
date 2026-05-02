// lib/screens/price_comparison/price_comparison_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lists_provider.dart';
import '../../providers/products_provider.dart';
import '../../models/product.dart';
import '../../widgets/price_comparison_card.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class PriceComparisonScreen extends ConsumerStatefulWidget {
  final String listId;

  const PriceComparisonScreen({super.key, required this.listId});

  @override
  ConsumerState<PriceComparisonScreen> createState() => _PriceComparisonScreenState();
}

class _PriceComparisonScreenState extends ConsumerState<PriceComparisonScreen> {
  String? _selectedProductId;

  List<Product> _uniqueProducts(List<Product> matched) {
    final map = <String, Product>{};
    for (final p in matched) {
      map[p.id] = p;
    }
    return map.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final lists = ref.watch(listsProvider);
    final shoppingList = lists.firstWhere((l) => l.id == widget.listId);
    final products = ref.watch(productsProvider);

    final matched = shoppingList.items
        .map(
          (item) => products.firstWhere(
            (p) => p.name.toLowerCase().contains(item.name.toLowerCase()),
            orElse: () => products.first,
          ),
        )
        .toList();
    final availableProducts = _uniqueProducts(matched);

    if (_selectedProductId == null && availableProducts.isNotEmpty) {
      _selectedProductId = availableProducts.first.id;
    }

    final selectedProduct = products.firstWhere(
      (p) => p.id == _selectedProductId,
      orElse: () => availableProducts.isNotEmpty ? availableProducts.first : products.first,
    );

    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(AppStrings.comparePrices),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pick a product from your list',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: AppSizes.sm),
            if (availableProducts.isEmpty)
              Text(
                'No matching catalog items for this list.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableProducts.map((p) {
                  final selected = p.id == _selectedProductId;
                  return FilterChip(
                    selected: selected,
                    label: Text(p.name),
                    onSelected: (_) {
                      setState(() => _selectedProductId = p.id);
                    },
                    showCheckmark: false,
                    selectedColor: scheme.primaryContainer,
                    labelStyle: TextStyle(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      color: selected ? scheme.primary : scheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: AppSizes.lg),
            if (availableProducts.isNotEmpty) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: selectedProduct.storePrices.length,
                  itemBuilder: (context, index) {
                    final storePrice = selectedProduct.storePrices[index];
                    final isBestDeal = storePrice.price == selectedProduct.currentLowestPrice;
                    return PriceComparisonCard(
                      storePrice: storePrice,
                      isBestDeal: isBestDeal,
                      lowestPrice: selectedProduct.currentLowestPrice,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              Container(
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success.withValues(alpha: 0.12),
                      scheme.primaryContainer.withValues(alpha: 0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
                ),
                child: Column(
                  children: [
                    Text(
                      '${AppStrings.youSave} Rs. ${_calculateSavings(selectedProduct).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${AppStrings.byChoosing} ${selectedProduct.bestStore}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          ref.read(productsProvider.notifier).toggleTracking(selectedProduct.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                selectedProduct.isTracked
                                    ? 'Removed from tracking'
                                    : AppStrings.productTracked,
                              ),
                            ),
                          );
                          setState(() {});
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              selectedProduct.isTracked ? scheme.error : scheme.primary,
                        ),
                        child: Text(
                          selectedProduct.isTracked ? 'Stop tracking' : AppStrings.trackThisProduct,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _calculateSavings(Product product) {
    if (product.storePrices.isEmpty) return 0;
    final highestPrice = product.storePrices.map((sp) => sp.price).reduce((a, b) => a > b ? a : b);
    return highestPrice - product.currentLowestPrice;
  }
}
