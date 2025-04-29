import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future<void> login(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    final userViewModel = context.read<UserViewModel>();

    // trocar esses valores pelos campos do textField
    final result = await authViewModel.login("ana@gmail.com", "ana123");

    if (result) {
      userViewModel.fetchUser();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Login feito com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorPrimary,
      ));
      // Navigator.pushReplacementNamed(context, "/home");
    } else if (authViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          authViewModel.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

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
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => login(context),
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
        ));
  }
}
