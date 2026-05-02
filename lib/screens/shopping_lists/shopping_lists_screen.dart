// lib/screens/shopping_lists/shopping_lists_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../widgets/list_card.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_colors.dart';

class ShoppingListsScreen extends ConsumerWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listsProvider);
    final activeLists = lists.where((l) => !l.isCompleted).toList();
    final completedLists = lists.where((l) => l.isCompleted).toList();
    final scheme = Theme.of(context).colorScheme;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLow.withValues(alpha: 0.4),
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
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppSizes.radiusXl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
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
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(AppStrings.sortComingSoon)),
                          );
                        },
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                        ),
                        icon: const Icon(Icons.sort_rounded),
                      ),
                    ],
                  ),
                  Text(
                    AppStrings.myLists,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.listsScreenSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.35,
                        ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.playlist_play_rounded,
                        label: '${activeLists.length} ${AppStrings.active}',
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Icons.check_circle_outline_rounded,
                        label: '${completedLists.length} ${AppStrings.done}',
                        color: Colors.white,
                      ),
                    ],
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
                  padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
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
                  padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.lg, AppSizes.md, AppSizes.sm),
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
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
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
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13),
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
          Text(
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
