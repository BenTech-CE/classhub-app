import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/views/auth/login/LoginView.dart';
import 'package:flutter/material.dart';

void main() {
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