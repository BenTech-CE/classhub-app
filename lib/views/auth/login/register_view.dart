import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  Future<void> register(BuildContext context) async {
    final authViewModel = context.read<AuthViewModel>();
    final userViewModel = context.read<UserViewModel>();

    // trocar esses valores pelos campos do textField
    final result =
        await authViewModel.register("João", "joão@gmail.com", "joão123");

    if (result) {
      // colocar o fetchUser no main geral
      userViewModel.fetchUser();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Cadastro feito com sucesso!",
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
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
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
                const SizedBox(height: 12),
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
                    onPressed: () => register(context),
                    child: loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ))
                        : const Text("Cadastrar"),
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
