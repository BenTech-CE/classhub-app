import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/classes/sheets/create_or_join_sheet.dart';
import 'package:classhub/views/user/widgets/class_card.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
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

    userViewModel.fetchCachedUser();

    await userViewModel.fetchUser();
    print(userViewModel.error);
    if (userViewModel.error != null) {
      // se der algum erro na hora de encontrar as info do user, jogamos de volta para o login (pois o token pode nao ser mais valido ou o user nem está logado)
      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginView()));
      return;
    }
  }

  void _sheetCreateOrJoinClass(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (BuildContext context) => const CreateOrJoinSheet());
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _userInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    //final double height = MediaQuery.of(context).size.height;

    final authViewModel = context.watch<AuthViewModel>();
    final userViewModel = context.watch<UserViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Suas Turmas"),
        actionsPadding: const EdgeInsets.only(right: 5),
        actions: [
          IconButton(
            onPressed: () {
              authViewModel.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginView()));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sheetCreateOrJoinClass(context);
        },
        shape: const CircleBorder(),
        backgroundColor: cColorPrimary,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                sPadding, sPadding, sPadding, sPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20.0,
              children: [
                // Verificamos se o usuário tem turmas ai mapeamos cada turma para uma instância de Card de Turma (figma)
                (userViewModel.user != null)
                    ? Column(
                        spacing: sSpacing,
                        children: userViewModel.user!.classes.map((turma) {
                          return ClassCard(turma: turma);
                        }).toList())
                    : Column(
                        spacing: sSpacing,
                        children: [
                          Text("Aguarde enquanto carregamos suas turmas...",
                              style: Theme.of(context).textTheme.titleMedium),
                          const LoadingWidget(
                            color: cColorPrimary,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
