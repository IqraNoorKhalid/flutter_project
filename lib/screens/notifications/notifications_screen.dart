// lib/screens/notifications/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/site_page_header.dart';
import '../../core/layout/app_layout.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final scheme = Theme.of(context).colorScheme;
    final gutter = AppLayout.pageGutter(context);

    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SitePageHeader(
              title: AppStrings.notifications,
              subtitle: unreadCount > 0 ? '$unreadCount unread' : 'You are all caught up',
              leading: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              trailing: [
                if (unreadCount > 0)
                  FilledButton.tonal(
                    onPressed: () {
                      ref.read(notificationsProvider.notifier).markAllAsRead();
                    },
                    child: const Text(AppStrings.markAllRead),
                  ),
              ],
            ),
          ),
          if (notifications.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off_outlined, size: 72, color: scheme.outline),
                      const SizedBox(height: AppSizes.md),
                      Text(
                        AppStrings.noNotifications,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(gutter, AppSizes.lg, gutter, 32),
              sliver: SliverList.separated(
                itemCount: notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  final iconColor = _getIconColor(notification.type);
                  final unread = !notification.isRead;

                  return Material(
                    color: scheme.surface,
                    elevation: 0,
                    shadowColor: AppColors.shadow,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                      onTap: () {
                        if (unread) {
                          ref.read(notificationsProvider.notifier).markAsRead(notification.id);
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                          border: Border.all(
                            color: unread
                                ? iconColor.withValues(alpha: 0.35)
                                : scheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                          color: unread ? iconColor.withValues(alpha: 0.06) : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: iconColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_getIcon(notification.type), color: iconColor, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notification.title,
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                        if (unread)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: AppColors.secondary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification.body,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                            height: 1.35,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      notification.timeAgo,
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: scheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'price_drop':
        return Icons.trending_down_rounded;
      case 'deal':
        return Icons.local_offer_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'price_drop':
        return AppColors.success;
      case 'deal':
        return AppColors.secondary;
      case 'reminder':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }
}
