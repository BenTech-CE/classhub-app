import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  Future<void> login(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    final result = await authViewModel.login("email", "password");

    if (result) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(
            sPadding, sPadding + 55, sPadding, sPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
                backgroundImage: AssetImage("assets/logo/logo.jpeg"),
                radius: 60),
            const SizedBox(height: 24),
            Text(
              "Bem-vindo(a)\nde volta!",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 40),
            ),
            const SizedBox(height: 50),
            Text(
              "E-mail:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu e-mail..."),
            ),
            const SizedBox(height: 12),
            Text(
              "Senha:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite sua senha..."),
            ),
            SizedBox(
                width: double.maxFinite,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text("Esqueceu a senha?",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: cColorSecond)))
                    ])),
            const SizedBox(height: 24),
            SizedBox(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                    onPressed: () => login(context),
                    child: const Text("Entrar"))),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Não tem uma conta?",
                    style: Theme.of(context).textTheme.bodyLarge),
                TextButton(
                    onPressed: () {},
                    child: Text("Registre-se",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cColorSecond)))
              ],
            )
          ],
        ),
      ),
    );
  }
}
