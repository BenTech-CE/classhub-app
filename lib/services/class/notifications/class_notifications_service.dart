import 'dart:convert';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/notifications/notification_class.dart';
import 'package:classhub/models/class/notifications/notification_type.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:classhub/services/class/notifications/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:mmkv/mmkv.dart';

class ClassNotificationsService {
  final AuthService authService;
  final NotificationService notificationService = NotificationService();
  var mmkv = MMKV.defaultMMKV();

  ClassNotificationsService(this.authService);

  Future<bool> subscribe(
      NotificationType notificationType, String classId) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final fcmToken = await notificationService.getFcmToken();
    if (fcmToken == null) throw Exception('FCM Token não encontrado');

    final response = await http.post(
        Uri.parse("${Api.baseUrl}${Api.classEndpoint}/$classId/subscribe"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(NotificationClass(
                notificationType: notificationType, fcmToken: fcmToken)
            .toJson()));

    print("Response from subscribe notification:");
    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {

      mmkv.encodeBool("notifications.$classId.${notificationType.name}", true);

      return true;
    } else {
      throw Exception(
          "Erro ao enviar a notificação $notificationType: ${jsonResponse["error"]}");
    }
  }

  Future<bool> unsubscribe(
      NotificationType notificationType, String classId) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final fcmToken = await notificationService.getFcmToken();
    if (fcmToken == null) throw Exception('FCM Token não encontrado');

    final response = await http.post(
        Uri.parse("${Api.baseUrl}${Api.classEndpoint}/$classId/unsubscribe"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(NotificationClass(
                notificationType: notificationType, fcmToken: fcmToken)
            .toJson()));

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mmkv.encodeBool("notifications.$classId.${notificationType.name}", false);

      return true;
    } else {
      throw Exception(
          "Erro ao unsubscribe a notificação $notificationType: ${jsonResponse["error"]}");
    }
  }

  bool isSubscribedTo(NotificationType notificationType, String classId) {
    final key = "notifications.$classId.${notificationType.name}";

    if (mmkv.containsKey(key)) {
      return mmkv.decodeBool(key);
    } else {
      return false;
    }
  }

  void subscribeDefaults(String classId) {
    mmkv.encodeBool("notifications.$classId.${NotificationType.new_alert.name}", true);

    mmkv.encodeBool("notifications.$classId.${NotificationType.new_material.name}", true);

    mmkv.encodeBool("notifications.$classId.${NotificationType.event_created.name}", true);
  }
}
