import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:classhub/services/auth/session_service.dart';
import 'package:classhub/services/class/management/class_management_service.dart';
import 'package:classhub/services/class/members/class_members_service.dart';
import 'package:classhub/services/class/subjects/class_subjects_service.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/viewmodels/class/members/class_members_viewmodel.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/user/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mmkv/mmkv.dart';
import 'package:provider/provider.dart';

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(sessionService)),
        ChangeNotifierProvider(create: (_) => AuthViewModel(authService)),
        ChangeNotifierProvider(
            create: (_) => ClassSubjectsViewModel(classSubjectsService)),
        ChangeNotifierProvider(
            create: (_) => ClassMembersViewModel(classMembersService)),
        ChangeNotifierProvider(
            create: (_) => ClassManagementViewModel(classManagementService)),
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
