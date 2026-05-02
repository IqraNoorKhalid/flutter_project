// lib/providers/notifications_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_notification.dart';
import '../dummy_data/dummy_data.dart';

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super(DummyData.notifications);

  void markAsRead(String notificationId) {
    state = state.map((notification) {
      if (notification.id != notificationId) return notification;
      return notification.copyWith(isRead: true);
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((notification) {
      return notification.copyWith(isRead: true);
    }).toList();
  }

  int get unreadCount {
    return state.where((n) => !n.isRead).length;
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});