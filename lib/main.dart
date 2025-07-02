import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:classhub/services/auth/session_service.dart';
import 'package:classhub/services/class/calendar/class_calendar_service.dart';
import 'package:classhub/services/class/management/class_management_service.dart';
import 'package:classhub/services/class/members/class_members_service.dart';
import 'package:classhub/services/class/mural/class_mural_service.dart';
import 'package:classhub/services/class/notifications/class_notifications_service.dart';
import 'package:classhub/services/class/notifications/notification_service.dart';
import 'package:classhub/services/class/subjects/class_subjects_service.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/calendar/class_calendar_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/viewmodels/class/members/class_members_viewmodel.dart';
import 'package:classhub/viewmodels/class/mural/class_mural_viewmodel.dart';
import 'package:classhub/viewmodels/class/notifications/class_members_viewmodel.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/views/user/splash_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mmkv/mmkv.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Cor da barra de status
    statusBarIconBrightness:
        Brightness.dark, // Ícones escuros na barra de status
    systemNavigationBarColor: Colors.white, // Cor da barra de navegação
    systemNavigationBarIconBrightness:
        Brightness.dark, // Ícones escuros na barra de navegação
  ));

  final rootDir = await MMKV.initialize(); // Inicializando o banco de dados
  print('MMKV for flutter with rootDir = $rootDir');

  await initializeDateFormatting('pt_BR');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final NotificationService notificationService = NotificationService();
  await notificationService.initFCM();

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final sessionService = SessionService(authService);
    final classManagementService = ClassManagementService(authService);
    final classMembersService = ClassMembersService(authService);
    final classSubjectsService = ClassSubjectsService(authService);
    final classMuralService = ClassMuralService(authService);
    final classCalendarService = ClassCalendarService(authService);
    final classNotificationsService = ClassNotificationsService(authService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(sessionService)),
        ChangeNotifierProvider(create: (_) => AuthViewModel(authService)),
        ChangeNotifierProvider(
            create: (_) => ClassMuralViewModel(classMuralService)),
        ChangeNotifierProvider(
            create: (_) => ClassSubjectsViewModel(classSubjectsService)),
        ChangeNotifierProvider(
            create: (_) => ClassMembersViewModel(classMembersService)),
        ChangeNotifierProvider(
            create: (_) => ClassManagementViewModel(classManagementService)),
        ChangeNotifierProvider(
            create: (_) =>
                ClassNotificationsViewModel(classNotificationsService)),
        ChangeNotifierProvider(
            create: (_) => ClassCalendarViewModel(classCalendarService)),
      ],
      child: MaterialApp(
        title: 'Classhub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const SplashView(),
      ),
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.data}');
}
