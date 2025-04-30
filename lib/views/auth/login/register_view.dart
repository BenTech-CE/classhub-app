import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    final authViewModel = context.watch<AuthViewModel>();
    final loading = authViewModel.isLoading;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: height,
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
                  "Nome:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Digite seu nome..."),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ))
                        : const Text("Entrar"),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Já tem uma conta?",
                        style: Theme.of(context).textTheme.bodyLarge),
                    TextButton(
                        onPressed: () {},
                        child: Text("Entrar",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: cColorSecond)))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}