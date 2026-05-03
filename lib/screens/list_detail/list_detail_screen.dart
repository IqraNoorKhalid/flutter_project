// lib/screens/list_detail/list_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/store_badge.dart';
import '../../core/layout/app_layout.dart';

class ListDetailScreen extends ConsumerWidget {
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listsProvider);
    final shoppingList = lists.firstWhere((l) => l.id == listId);
    final scheme = Theme.of(context).colorScheme;

    final gutter = AppLayout.pageGutter(context);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            stretch: true,
            backgroundColor: scheme.surface,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/lists');
                }
              },
            ),
            actions: [
              IconButton(
                onPressed: () => context.go('/lists/edit', extra: listId),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit list',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                shoppingList.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              expandedTitleScale: 1.05,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.sm, gutter, AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shoppingList.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: shoppingList.tags.map((t) {
                        return StoreBadge(
                          text: t,
                          color: scheme.secondaryContainer.withValues(alpha: 0.6),
                          textColor: scheme.onSecondaryContainer,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppSizes.md),
                  ],
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary.withValues(alpha: 0.1),
                          scheme.primaryContainer.withValues(alpha: 0.45),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            Text(
                              '${shoppingList.completedItemsCount} / ${shoppingList.items.length}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.sm),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: shoppingList.completionPercentage,
                            backgroundColor: scheme.surface.withValues(alpha: 0.65),
                            valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                            minHeight: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (shoppingList.items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.playlist_add_rounded, size: 56, color: scheme.outline),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        'No items yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'Edit this list to add groceries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSizes.lg),
                      FilledButton.icon(
                        onPressed: () => context.go('/lists/edit', extra: listId),
                        icon: const Icon(Icons.edit_rounded),
                        label: const Text('Edit list'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, 0, gutter, AppSizes.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = shoppingList.items[index];
                    final checked = item.isChecked;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: Slidable(
                        key: ValueKey(item.id),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.22,
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                HapticFeedback.mediumImpact();
                                ref.read(listsProvider.notifier).removeItemFromList(listId, item.id);
                              },
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                              icon: Icons.delete_outline_rounded,
                              label: 'Remove',
                            ),
                          ],
                        ),
                        child: Material(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            onTap: () {
                              ref.read(listsProvider.notifier).toggleItemCheck(listId, item.id);
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                                border: Border.all(
                                  color: checked
                                      ? scheme.outlineVariant.withValues(alpha: 0.35)
                                      : scheme.outlineVariant.withValues(alpha: 0.55),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: checked,
                                      onChanged: (_) {
                                        ref.read(listsProvider.notifier).toggleItemCheck(listId, item.id);
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  decoration: checked ? TextDecoration.lineThrough : null,
                                                  color: checked ? scheme.onSurfaceVariant : scheme.onSurface,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${item.quantity} ${item.unit}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: scheme.onSurfaceVariant,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Rs. ${item.lowestPrice.toStringAsFixed(0)}',
                                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                color: AppColors.success,
                                              ),
                                        ),
                                        const SizedBox(height: 6),
                                        StoreBadge(
                                          text: item.bestStore.isEmpty ? '—' : item.bestStore,
                                          color: scheme.primaryContainer,
                                          textColor: scheme.primary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: shoppingList.items.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 180)),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 16,
        shadowColor: AppColors.shadow,
        color: scheme.surface,
        child: SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.35)),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, AppSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated total',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      'Rs. ${shoppingList.totalEstimatedCost.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.success,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.md),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => context.go('/lists/$listId/compare'),
                    icon: const Icon(Icons.compare_arrows_rounded),
                    label: const Text('Compare store prices'),
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
