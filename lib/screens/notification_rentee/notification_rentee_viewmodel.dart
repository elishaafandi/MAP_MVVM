import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/notification_model.dart';
import 'package:movease/services/notification/notification_service.dart';


class NotificationViewModel extends Viewmodel {
  final NotificationService _notificationService;
  final String currentUserId;

  NotificationViewModel({
    required NotificationService notificationService,
    required this.currentUserId,
  }) : _notificationService = notificationService;

  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationService.getNotifications(currentUserId);

  String formatTimestamp(DateTime timestamp) {
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