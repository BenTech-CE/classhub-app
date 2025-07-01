import 'package:classhub/models/class/notifications/notification_type.dart';

class NotificationClass {
  final NotificationType notificationType;
  final String fcmToken;

  NotificationClass({
    required this.notificationType,
    required this.fcmToken,
  });

  Map<String, String> toJson() {
    return {
      'notification-type': notificationType.name,
      'fcm-token': fcmToken,
    };
  }
}
