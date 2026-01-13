import 'package:flutter/material.dart';

import '../../../globals/theme.dart';
import '../../../globals/text_styles.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  List<NotificationItem> _mockNotifications() {
    return [
      NotificationItem(
        id: '1',
        title: '30% Discount on Bestsellers!',
        message: 'Limited time offer on top Computer Science books.',
        date: DateTime.now(),
        type: NotificationType.offer,
      ),
      NotificationItem(
        id: '2',
        title: 'Order Shipped',
        message: 'Your order #AB1023 is on the way.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.order,
      ),
      NotificationItem(
        id: '3',
        title: 'New Arrivals',
        message: 'Explore newly added Engineering textbooks.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.system,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _mockNotifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const BackButton(),
      ),
      body: notifications.isEmpty
          ? const _EmptyState()
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _Section(
                  title: 'Today',
                  items: notifications
                      .where((n) =>
                          n.date.day == DateTime.now().day &&
                          n.date.month == DateTime.now().month)
                      .toList(),
                ),
                _Section(
                  title: 'Earlier',
                  items: notifications
                      .where((n) => n.date.isBefore(
                            DateTime.now().subtract(const Duration(days: 1)),
                          ))
                      .toList(),
                ),
              ],
            ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<NotificationItem> items;

  const _Section({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.md),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _iconForType(item.type),
                color: AppColors.textPrimary,
              ),
              title: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body,
              ),
              subtitle: Text(
                item.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.local_shipping_outlined;
      case NotificationType.offer:
        return Icons.local_offer_outlined;
      case NotificationType.account:
        return Icons.person_outline;
      case NotificationType.system:
      default:
        return Icons.notifications_none;
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'You haven’t gotten any notifications yet!',
              style: AppTextStyles.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We’ll notify you when something important happens.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
