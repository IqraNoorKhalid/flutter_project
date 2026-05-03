// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/deals_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/list_card.dart';
import '../../widgets/deal_card.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/app_cart_button.dart';
import '../../widgets/site_page_header.dart';
import '../../core/layout/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/category_visual.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _timeGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listsProvider);
    final trackedProducts = ref.watch(trackedProductsProvider);
    final deals = ref.watch(dealsProvider);
    final products = ref.watch(productsProvider);
    final recentLists = lists.take(3).toList();
    final hotDeals = deals.take(5).toList();
    final featured = products.take(6).toList();
    final scheme = Theme.of(context).colorScheme;
    final gutter = AppLayout.pageGutter(context);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SitePageHeader(
              title: AppStrings.greeting,
              subtitle: '${_timeGreeting()} · ${AppStrings.tagline}',
              trailing: [
                IconButton(
                  onPressed: () => context.push('/notifications'),
                  icon: const Icon(Icons.notifications_none_rounded),
                ),
                const AppCartButton(),
              ],
              bottom: Material(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  onTap: () => context.push('/search'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 2),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: scheme.onSurfaceVariant),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            AppStrings.searchProducts,
                            style: TextStyle(color: scheme.onSurfaceVariant, fontSize: AppSizes.fontSizeMd),
                          ),
                        ),
                        Icon(Icons.tune_rounded, size: 20, color: scheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.storefront_rounded,
                      label: AppStrings.shop,
                      onTap: () => context.go('/shop'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.local_offer_rounded,
                      label: AppStrings.todaysDeals,
                      onTap: () => context.push('/deals'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.compare_arrows_rounded,
                      label: AppStrings.compare,
                      onTap: () {
                        if (lists.isNotEmpty) {
                          context.push('/lists/${lists.first.id}/compare');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Create a list to compare prices')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.md, gutter, AppSizes.md),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Active lists',
                      value: lists.where((l) => !l.isCompleted).length.toString(),
                      icon: Icons.checklist_rounded,
                      accent: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: _StatCard(
                      title: 'Tracked',
                      value: trackedProducts.length.toString(),
                      icon: Icons.favorite_rounded,
                      accent: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: _StatCard(
                      title: 'Deals',
                      value: deals.length.toString(),
                      icon: Icons.sell_rounded,
                      accent: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (recentLists.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(gutter, 0, gutter, AppSizes.sm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent lists',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => context.go('/lists'),
                      child: const Text('View all'),
                    ),
                  ],
                ),
              ),
            ),
          if (recentLists.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 188,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: gutter),
                  itemCount: recentLists.length,
                  itemBuilder: (context, index) {
                    final list = recentLists[index];
                    return SizedBox(
                      width: 300,
                      child: ListCard(
                        list: list,
                        onTap: () => context.go('/lists/${list.id}'),
                        onEdit: () => context.go('/lists/edit', extra: list.id),
                        onDelete: () => ref.read(listsProvider.notifier).deleteList(list.id),
                      ),
                    );
                  },
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured picks',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.go('/shop'),
                    child: const Text('Shop'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 132,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: gutter),
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
                itemBuilder: (context, index) {
                  final p = featured[index];
                  final vis = CategoryVisual.forCategory(p.category);
                  return _FeaturedChip(
                    productName: p.name,
                    price: p.currentLowestPrice,
                    icon: vis.icon,
                    onTap: () => context.push('/products/${p.id}'),
                    onAdd: () {
                      ref.read(cartProvider.notifier).addProduct(p);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('${p.name} ${AppStrings.addedToCart}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hot deals',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.push('/deals'),
                    child: const Text('View all'),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 232,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: gutter),
                itemCount: hotDeals.length,
                itemBuilder: (context, index) {
                  final deal = hotDeals[index];
                  return DealCard(
                    deal: deal,
                    forCarousel: true,
                    onTap: () => context.push('/deals'),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 88)),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.md, horizontal: AppSizes.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: scheme.primary, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      height: 1.15,
                      color: scheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 10,
              height: 1.2,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedChip extends StatelessWidget {
  const _FeaturedChip({
    required this.productName,
    required this.price,
    required this.icon,
    required this.onTap,
    required this.onAdd,
  });

  final String productName;
  final double price;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 148,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        scheme.primaryContainer.withValues(alpha: 0.35),
                        scheme.primary.withValues(alpha: 0.2),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(child: Icon(icon, color: scheme.primary.withValues(alpha: 0.85), size: 40)),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Material(
                          color: scheme.surface,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onAdd,
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(Icons.add_rounded, size: 18, color: scheme.primary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rs. ${price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
