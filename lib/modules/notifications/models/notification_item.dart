class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.type,
  });
}

enum NotificationType {
  order,
  offer,
  system,
  account,
}
