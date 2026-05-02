// lib/screens/product_detail/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/products_provider.dart';
import '../../providers/lists_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product.dart';
import '../../models/shopping_list.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/price_comparison_card.dart';
import '../../widgets/product_photo.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? _selectedListId;

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final product = products.firstWhere((p) => p.id == widget.productId);
    final lists = ref.watch(listsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(cartProvider.notifier).addProduct(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('${product.name} ${AppStrings.addedToCart}'),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart_rounded),
            tooltip: AppStrings.cart,
          ),
          IconButton(
            onPressed: () => _showAddToListDialog(product, lists),
            icon: const Icon(Icons.playlist_add_rounded),
            tooltip: AppStrings.addToList,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: ProductPhoto(
                  product: product,
                  height: 220,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  iconSize: 72,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: AppSizes.fontSizeTitle,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm,
                          vertical: AppSizes.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            color: AppColors.secondaryDark,
                            fontSize: AppSizes.fontSizeSm,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(productsProvider.notifier).toggleTracking(product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          product.isTracked ? 'Removed from tracking' : AppStrings.productTracked,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    product.isTracked ? Icons.favorite : Icons.favorite_border,
                    color: product.isTracked ? AppColors.error : null,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            // Price History Chart
            const Text(
              'Price History (6 months)',
              style: TextStyle(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: product.priceHistory.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.price);
                      }).toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            // Store Prices Section
            const Text(
              'Store Prices',
              style: TextStyle(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.md),
            ...product.storePrices.map((storePrice) {
              final isBestDeal = storePrice.price == product.currentLowestPrice;
              return PriceComparisonCard(
                storePrice: storePrice,
                isBestDeal: isBestDeal,
                lowestPrice: product.currentLowestPrice,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showAddToListDialog(Product product, List<ShoppingList> lists) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to List'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return DropdownButtonFormField<String>(
                hint: const Text('Select a list'),
                value: _selectedListId,
                items: lists.map((list) {
                  return DropdownMenuItem<String>(
                    value: list.id,
                    child: Text(list.name),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setDialogState(() {
                    _selectedListId = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedListId != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item added to list')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}