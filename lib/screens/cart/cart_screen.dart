// lib/screens/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../models/product.dart';
import '../../widgets/product_photo.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_colors.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  Product? _productForLine(List<Product> products, String productId) {
    for (final p in products) {
      if (p.id == productId) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final products = ref.watch(productsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(AppStrings.cart),
        actions: [
          if (lines.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart cleared')),
                );
              },
              child: const Text('Clear'),
            ),
        ],
      ),
      body: lines.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            scheme.primary.withValues(alpha: 0.12),
                            AppColors.accentIndigo.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                      child: Icon(Icons.shopping_bag_outlined, size: 56, color: scheme.primary),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      AppStrings.cartEmptyTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      AppStrings.cartEmptySubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: lines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      final product = _productForLine(products, line.productId);

                      return Material(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: product != null
                                        ? ProductPhoto(
                                            product: product,
                                            width: 64,
                                            height: 64,
                                            borderRadius: BorderRadius.circular(12),
                                            iconSize: 28,
                                          )
                                        : ColoredBox(
                                            color: scheme.primaryContainer,
                                            child: Icon(Icons.inventory_2_rounded, color: scheme.primary),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        line.name,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        line.category,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Rs. ${line.unitPrice.toStringAsFixed(0)} each',
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              color: AppColors.success,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton.filledTonal(
                                          onPressed: () => ref
                                              .read(cartProvider.notifier)
                                              .decrementOrRemove(line.productId),
                                          style: IconButton.styleFrom(
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          icon: const Icon(Icons.remove_rounded, size: 20),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            '${line.quantity}',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                ),
                                          ),
                                        ),
                                        IconButton.filledTonal(
                                          onPressed: () {
                                            if (product != null) {
                                              ref.read(cartProvider.notifier).addProduct(product);
                                            }
                                          },
                                          style: IconButton.styleFrom(
                                            visualDensity: VisualDensity.compact,
                                          ),
                                          icon: const Icon(Icons.add_rounded, size: 20),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          ref.read(cartProvider.notifier).removeLine(line.productId),
                                      child: const Text(AppStrings.remove),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.surface,
                        scheme.primaryContainer.withValues(alpha: 0.25),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 20,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.subtotal,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            Text(
                              'Rs. ${subtotal.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.success,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Text(
                          AppStrings.demoCheckout,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: AppSizes.md),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                showDragHandle: true,
                                builder: (ctx) => Padding(
                                  padding: const EdgeInsets.all(AppSizes.lg),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 56),
                                      const SizedBox(height: AppSizes.md),
                                      Text(
                                        AppStrings.orderPlacedDemo,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: AppSizes.lg),
                                      FilledButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text(AppStrings.gotIt),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text(AppStrings.checkoutDemo),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
