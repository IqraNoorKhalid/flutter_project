// lib/screens/shopping_lists/shopping_lists_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../widgets/list_card.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/site_page_header.dart';
import '../../core/layout/app_layout.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_colors.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listsProvider);
    final activeLists = lists.where((l) => !l.isCompleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final completedLists = lists.where((l) => l.isCompleted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final scheme = Theme.of(context).colorScheme;
    final gutter = AppLayout.pageGutter(context);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SitePageHeader(
              title: AppStrings.myLists,
              subtitle: AppStrings.listsScreenSubtitle,
              leading: IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              trailing: [
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Newest lists first — swipe a list for edit or delete'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                  tooltip: 'Sort info',
                ),
              ],
              bottom: Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _StatChip(
                    scheme: scheme,
                    icon: Icons.playlist_play_rounded,
                    label: '${activeLists.length} ${AppStrings.active}',
                  ),
                  _StatChip(
                    scheme: scheme,
                    icon: Icons.check_circle_outline_rounded,
                    label: '${completedLists.length} ${AppStrings.done}',
                  ),
                ],
              ),
            ),
          ),
          if (lists.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _ListsEmpty(onCreate: () => context.go('/lists/create')),
            )
          else ...[
            if (activeLists.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, AppSizes.sm),
                  child: Text(
                    AppStrings.activeListsSection,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final list = activeLists[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    child: ListCard(
                      list: list,
                      onTap: () => context.go('/lists/${list.id}'),
                      onEdit: () => context.go('/lists/edit', extra: list.id),
                      onDelete: () => ref.read(listsProvider.notifier).deleteList(list.id),
                    ),
                  );
                },
                childCount: activeLists.length,
              ),
            ),
            if (completedLists.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, AppSizes.sm),
                  child: Text(
                    AppStrings.completedListsSection,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final list = completedLists[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: gutter),
                      child: ListCard(
                        list: list,
                        onTap: () => context.go('/lists/${list.id}'),
                        onEdit: () => context.go('/lists/edit', extra: list.id),
                        onDelete: () => ref.read(listsProvider.notifier).deleteList(list.id),
                      ),
                    );
                  },
                  childCount: completedLists.length,
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.go('/lists/create');
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.newList),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.scheme,
    required this.icon,
    required this.label,
  });

  final ColorScheme scheme;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListsEmpty extends StatelessWidget {
  const _ListsEmpty({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
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
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.accentIndigo.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Icon(Icons.shopping_cart_rounded, size: 56, color: scheme.primary),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            AppStrings.noListsTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            AppStrings.noListsSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
              fontSize: AppSizes.fontSizeMd,
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text(AppStrings.createFirstList),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
