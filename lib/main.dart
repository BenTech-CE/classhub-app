import 'package:app_links/app_links.dart';
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
import 'package:classhub/viewmodels/class/notifications/class_notifications_viewmodel.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/classes/sheets/join_class_sheet.dart';
import 'package:classhub/views/user/home_view.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  final _navigatorKey = GlobalKey<NavigatorState>();

  String? code;
  String? token;

  void _listenDeepLinks() async {
    // Links que abriram o app (frio)
    final initialLink = await _appLinks.getInitialLink();
    _handleLink(initialLink);

    // Links enquanto o app está rodando
    _appLinks.uriLinkStream.listen(_handleLink);
  }

  void _handleLink(Uri? uri) {
    if (uri == null) return;

    final pathSegments = uri.pathSegments;
    if (pathSegments.length == 1 && pathSegments.first.length == 6) {
      final codeFound = pathSegments.first;
      final userToken = MMKV.defaultMMKV().decodeString("classhub-user-token");

      if (userToken != null && userToken.isNotEmpty) {
        code = codeFound;

        // Garante que você está na tela inicial antes de empurrar outra
        _navigatorKey.currentState?.popUntil((route) => route.isFirst);

        showModalBottomSheet<void>(
          context: _navigatorKey.currentContext!, // <- CORRECTED LINE
          showDragHandle: true,
          isScrollControlled: true,
          builder: (BuildContext context) => JoinClassSheet(code: codeFound),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _listenDeepLinks();

    token = MMKV.defaultMMKV().decodeString("classhub-user-token");
  }
  
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final classNotificationsService = ClassNotificationsService(authService);
    final sessionService = SessionService(authService);
    final classManagementService = ClassManagementService(authService, classNotificationsService);
    final classMembersService = ClassMembersService(authService);
    final classSubjectsService = ClassSubjectsService(authService);
    final classMuralService = ClassMuralService(authService);
    final classCalendarService = ClassCalendarService(authService);
    

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
            create: (_) => ClassNotificationsViewModel(classNotificationsService)),
        ChangeNotifierProvider(
            create: (_) => ClassManagementViewModel(classManagementService)),
        ChangeNotifierProvider(
            create: (_) => ClassCalendarViewModel(classCalendarService)),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Classhub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: token == null ? const LoginView() : const HomeView(code: null),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Handling a background message: ${message.data}');
}
