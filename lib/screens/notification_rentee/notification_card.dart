import 'package:flutter/material.dart';
import 'package:movease/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  static const cardBlack = Color(0xFF1E1E1E);
  static const textGrey = Color(0xFFB3B3B3);

  const NotificationCard({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notification.color, width: 2),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: notification.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(notification.icon, color: notification.color, size: 24),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: const TextStyle(color: textGrey, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: const TextStyle(color: textGrey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
