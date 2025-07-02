import 'package:classhub/models/class/notifications/notification_type.dart';
import 'package:classhub/services/class/notifications/class_notifications_service.dart';
import 'package:flutter/material.dart';

class ClassNotificationsViewModel extends ChangeNotifier {
  final ClassNotificationsService classNotificationsService;

  bool isLoading = false;
  String? error;

  ClassNotificationsViewModel(this.classNotificationsService);

  Future<bool> subscribe(
      NotificationType notificationType, String classId) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classNotificationsService.subscribe(
          notificationType, classId);
    } catch (e) {
      print(e);
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> unsubscribe(
      NotificationType notificationType, String classId) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classNotificationsService.unsubscribe(
          notificationType, classId);
    } catch (e) {
      print(e);
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
