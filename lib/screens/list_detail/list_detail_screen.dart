// lib/screens/list_detail/list_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/lists_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../widgets/store_badge.dart';

class ListDetailScreen extends ConsumerWidget {
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(listsProvider);
    final shoppingList = lists.firstWhere((l) => l.id == listId);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(shoppingList.name),
        actions: [
          IconButton(
            onPressed: () => context.go('/lists/edit', extra: listId),
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Edit list',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.md, AppSizes.md, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary.withValues(alpha: 0.12),
                    scheme.primaryContainer.withValues(alpha: 0.35),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(color: scheme.primary.withValues(alpha: 0.15)),
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
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        '${shoppingList.completedItemsCount} / ${shoppingList.items.length}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: shoppingList.completionPercentage,
                      backgroundColor: scheme.surface.withValues(alpha: 0.7),
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.md),
              itemCount: shoppingList.items.length,
              itemBuilder: (context, index) {
                final item = shoppingList.items[index];
                final checked = item.isChecked;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
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
                          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                                            fontWeight: FontWeight.w700,
                                            decoration: checked ? TextDecoration.lineThrough : null,
                                            color: checked ? scheme.onSurfaceVariant : scheme.onSurface,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.quantity} ${item.unit}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: scheme.onSurfaceVariant,
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
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.success,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
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
                );
              },
            ),
          ),
          Material(
            elevation: 12,
            shadowColor: AppColors.shadow,
            color: scheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
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
                                fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}
