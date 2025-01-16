import 'package:movease/models/notification_model.dart';

abstract class NotificationService {
  Stream<List<NotificationModel>> getNotifications(String userId);
}