import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/sizes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(sPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // img
            Text(
              "Bem-vindo(a) de volta!",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40),
            ),
            Text(
              "E-mail",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Digite seu e-mail"),
            ),
            Text(
              "Senha",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Digite sua senha"),
            ),
            FilledButton(onPressed: () {}, child: const Text("Entrar"))
          ],
        ),
      ),
    );
  }
}
