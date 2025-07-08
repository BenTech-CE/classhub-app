import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/user/home_view.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nomeTF = TextEditingController();
  final _emailTF = TextEditingController();
  final _senhaTF = TextEditingController();

  final _nomeFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _senhaFocus = FocusNode();

  Future<void> register(BuildContext context) async {
    // Fecha o teclado
    FocusScope.of(context).unfocus();

    final authViewModel = context.read<AuthViewModel>();

    if (!EmailValidator.validate(_emailTF.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Insira um e-mail válido.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      return;
    }

    // trocar esses valores pelos campos do textField
    final result = await authViewModel.register(
        _nomeTF.text, _emailTF.text, _senhaTF.text);

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Cadastro feito com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));

      // navegando para a tela de início (a que aparece as turmas do usuário)
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeView(code: null,)));
    } else if (authViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          authViewModel.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));
    }
  }

  @override
  void dispose() {
    _nomeTF.dispose();
    _emailTF.dispose();
    _senhaTF.dispose();

    _nomeFocus.dispose();
    _emailFocus.dispose();
    _senhaFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final loading = authViewModel.isLoading;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  sPadding, sPadding, sPadding, sPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                      backgroundImage: AssetImage("assets/logo/logo.jpeg"),
                      radius: 60),
                  const SizedBox(height: 24),
                  Text(
                    "Bem-vindo(a)!",
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
                  TextField(
                    controller: _nomeTF,
                    focusNode: _nomeFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                    decoration: const InputDecoration(
                        border: RoundedInputBorder(),
                        hintText: "Digite seu nome..."),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "E-mail:",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextField(
                    controller: _emailTF,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_senhaFocus);
                    },
                    decoration: const InputDecoration(
                        border: RoundedInputBorder(),
                        hintText: "Digite seu e-mail..."),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Senha:",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextField(
                    controller: _senhaTF,
                    focusNode: _senhaFocus,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: RoundedInputBorder(),
                        hintText: "Digite sua senha..."),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.maxFinite,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => register(context),
                      child: loading
                          ? const LoadingWidget()
                          : Text("Cadastrar",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: cColorTextWhite)),
                    ),
                  ),
                  //const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Já tem uma conta?",
                          style: Theme.of(context).textTheme.bodyLarge),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginView()));
                          },
                          child: Text("Entrar",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: cColorPrimary)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
