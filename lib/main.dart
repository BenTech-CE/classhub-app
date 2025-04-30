import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:classhub/services/auth/session_service.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/auth/login/register_view.dart';
import 'package:flutter/material.dart';
import 'package:mmkv/mmkv.dart';
import 'package:provider/provider.dart';

void main() async {
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserViewModel(sessionService)),
        ChangeNotifierProvider(create: (_) => AuthViewModel(authService)),
      ],
      child: MaterialApp(
        title: 'Classhub',
        theme: AppTheme.theme,
        home: Container(
          color: Colors.white,
          child: const Center(
            child: RegisterView(),
          ), 
        ),
      ),
    );
  }
}
