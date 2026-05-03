// lib/screens/shop/shop_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/products_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/product.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/app_cart_button.dart';
import '../../widgets/product_photo.dart';
import '../../widgets/site_page_header.dart';
import '../../core/layout/app_layout.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/category_visual.dart';

class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  String _category = AppStrings.all;

  List<String> _categories(List<Product> products) {
    final set = products.map((p) => p.category).toSet().toList()..sort();
    return [AppStrings.all, ...set];
  }

  List<Product> _filtered(List<Product> products) {
    if (_category == AppStrings.all) return products;
    return products.where((p) => p.category == _category).toList();
  }

  IconData _chipIcon(String label) {
    if (label == AppStrings.all) return Icons.apps_rounded;
    return CategoryVisual.forCategory(label).icon;
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsProvider);
    final categories = _categories(products);
    final visible = _filtered(products);
    final scheme = Theme.of(context).colorScheme;
    final gutter = AppLayout.pageGutter(context);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SitePageHeader(
              title: AppStrings.shop,
              subtitle: '${AppStrings.shopHeroTitle}\n${AppStrings.shopHeroSubtitle}',
              trailing: const <Widget>[AppCartButton()],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, AppSizes.sm),
              child: Material(
                color: scheme.surface,
                elevation: 2,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push('/search');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.search_rounded, color: AppColors.primary),
                        ),
                        const SizedBox(width: AppSizes.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.searchProducts,
                                style: TextStyle(
                                  fontSize: AppSizes.fontSizeMd,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                              const Text(
                                AppStrings.tapToSearch,
                                style: TextStyle(
                                  fontSize: AppSizes.fontSizeXs,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: scheme.outline),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.sm, gutter, AppSizes.sm),
              child: Row(
                children: [
                  Icon(Icons.category_rounded, size: 20, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.shopCategories,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: gutter),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final c = categories[index];
                  final selected = _category == c;
                  return _CategoryPill(
                    label: c,
                    icon: _chipIcon(c),
                    selected: selected,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _category = c);
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.md, gutter, AppSizes.sm),
              child: Row(
                children: [
                  Text(
                    '${visible.length} ${AppStrings.items}',
                    style: const TextStyle(
                      fontSize: AppSizes.fontSizeSm,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: gutter),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.62,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = visible[index];
                  return _ProductGridTile(product: product);
                },
                childCount: visible.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Material(
        color: selected ? AppColors.primary : scheme.surface,
        elevation: selected ? 0 : 1,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: selected ? Colors.white : scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductGridTile extends ConsumerWidget {
  const _ProductGridTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final bottom = BorderRadius.circular(AppSizes.radiusLg);

    return Material(
      color: scheme.surface,
      borderRadius: bottom,
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: () => context.push('/products/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductPhoto(
                    product: product,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSizes.radiusLg),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                      child: const SizedBox(height: 48),
                    ),
                  ),
                  if (product.isTracked)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications_active_rounded, size: 14, color: AppColors.secondary),
                            SizedBox(width: 4),
                            Text(
                              'Tracked',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Material(
                      color: AppColors.primary,
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.5),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ref.read(cartProvider.notifier).addProduct(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              content: Text('${product.name} ${AppStrings.addedToCart}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.add_shopping_cart_rounded, size: 22, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Rs. ${product.currentLowestPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.success,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppStrings.lowestPriceLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
