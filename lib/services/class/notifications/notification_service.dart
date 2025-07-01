import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  initFCM() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await firebaseMessaging.getToken();
    print('FCM Token: $fcmToken');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Received a message while in the foreground: ${message.data}');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground: ${message.data}');
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  getFcmToken() async {
    final fcmToken = await firebaseMessaging.getToken();
    return fcmToken;
  }
}
