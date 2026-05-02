// lib/screens/store_deals/store_deals_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/deals_provider.dart';
import '../../models/store_offer.dart';
import '../../widgets/deal_card.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/category_visual.dart';

class StoreDealsScreen extends ConsumerStatefulWidget {
  const StoreDealsScreen({super.key});

  @override
  ConsumerState<StoreDealsScreen> createState() => _StoreDealsScreenState();
}

class _StoreDealsScreenState extends ConsumerState<StoreDealsScreen> {
  String _selectedCategory = AppStrings.all;

  late final List<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = [
      AppStrings.all,
      AppStrings.dairy,
      AppStrings.bakery,
      AppStrings.meat,
      AppStrings.grains,
      AppStrings.beverages,
      AppStrings.essentialsTag,
    ];
  }

  IconData _iconForCategory(String label) {
    if (label == AppStrings.all) return Icons.local_offer_rounded;
    return CategoryVisual.forCategory(label).icon;
  }

  List<StoreOffer> _filtered() {
    ref.watch(dealsProvider);
    final notifier = ref.read(dealsProvider.notifier);
    final mapCategory = _selectedCategory == AppStrings.all ? 'All' : _selectedCategory;
    return notifier.filterByCategory(mapCategory);
  }

  @override
  Widget build(BuildContext context) {
    final filteredDeals = _filtered();
    final scheme = Theme.of(context).colorScheme;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow.withValues(alpha: 0.45),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(AppSizes.md, top + AppSizes.md, AppSizes.md, AppSizes.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE65100), Color(0xFFBF360C)],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppSizes.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              AppStrings.dealsLiveBadge,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.todaysDeals,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.dealsScreenSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                          height: 1.35,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
              child: Row(
                children: [
                  Icon(Icons.filter_alt_rounded, size: 20, color: scheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.shopCategories,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final c = _categories[index];
                  final selected = _selectedCategory == c;
                  return _DealCategoryPill(
                    label: c,
                    icon: _iconForCategory(c),
                    selected: selected,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _selectedCategory = c;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredDeals.length} ${AppStrings.dealsAvailable}',
                    style: const TextStyle(
                      fontSize: AppSizes.fontSizeSm,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/shop'),
                    icon: const Icon(Icons.storefront_rounded, size: 18),
                    label: const Text(AppStrings.browseFullShop),
                  ),
                ],
              ),
            ),
          ),
          if (filteredDeals.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_offer_outlined, size: 64, color: scheme.outline),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        AppStrings.noDealsInCategory,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      const Text(
                        AppStrings.tryAnotherCategory,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: AppSizes.md,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final deal = filteredDeals[index];
                    return DealCard(
                      deal: deal,
                      forCarousel: false,
                      onTap: () => _openDealSheet(context, deal),
                    );
                  },
                  childCount: filteredDeals.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }

  void _openDealSheet(BuildContext context, StoreOffer deal) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(deal.productName, style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSizes.sm),
            Text(
              '${deal.storeName} · ${deal.category}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Text(
                  'Rs. ${deal.salePrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  'Rs. ${deal.originalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/shop');
                },
                icon: const Icon(Icons.shopping_bag_rounded),
                label: const Text(AppStrings.findInShop),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealCategoryPill extends StatelessWidget {
  const _DealCategoryPill({
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
        color: selected ? AppColors.secondary : scheme.surface,
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
