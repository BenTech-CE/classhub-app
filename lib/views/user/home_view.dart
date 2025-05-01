import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _userInfo(BuildContext ctx) async {
    final userViewModel = ctx.read<UserViewModel>();

    await userViewModel.fetchUser();

    if (userViewModel.error != null) {
      // se der algum erro na hora de encontrar as info do user, jogamos de volta para o login (pois o token pode nao ser mais valido ou o user nem está logado)
      Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (context) => const LoginView()));
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    print("init state..");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _userInfo(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    final userViewModel = context.watch<UserViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Container(
          height: height,
          padding: const EdgeInsets.fromLTRB(
              sPadding, sPadding * 4, sPadding, sPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Bem-vindo, ${userViewModel.user?.name}!", style: Theme.of(context).textTheme.labelLarge),
              Text("Você está em ${userViewModel.user?.classes.length} turmas.", style: Theme.of(context).textTheme.labelLarge)
            ]
          )
        )
      )
    );
  }
}