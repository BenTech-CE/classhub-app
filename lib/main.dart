import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:mmkv/mmkv.dart';

void main() async {
  final rootDir = await MMKV.initialize();
  print('MMKV for flutter with rootDir = $rootDir');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classhub',
      theme: AppTheme.theme,
      home: Container(
        color: Colors.white,
        child: const Center(
          child: LoginView(),
        ),
      ),
    );
  }
}
