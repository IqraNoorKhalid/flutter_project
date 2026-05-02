// lib/models/app_notification.dart
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // price_drop, deal, reminder
  final DateTime createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}