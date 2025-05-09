import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/class_model.dart';
import 'package:classhub/models/class/class_owner_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
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

    await userViewModel.fetchUser();
    print(userViewModel.error);
    if (userViewModel.error != null) {
      // se der algum erro na hora de encontrar as info do user, jogamos de volta para o login (pois o token pode nao ser mais valido ou o user nem está logado)
      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginView()));
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
    final classManagementViewModel = context.watch<ClassManagementViewModel>();

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
              Text("Bem-vindo, ${userViewModel.user?.name}!",
                  style: Theme.of(context).textTheme.labelLarge),
              Text("Você está em ${userViewModel.user?.classes.length} turmas.",
                  style: Theme.of(context).textTheme.labelLarge),
              Text("${0xFF024D94}"),
              CircleAvatar(backgroundColor: Color(0xFF024D94)),
              Container(
                height: 20,
              ),
              // TESTANDO A CRIAÇÃO DE TURMAS
              OutlinedButton(
                  onPressed: () async {
                    final classModel = ClassModel(
                      name: "Inglês (Mael)",
                      school: "Escola de Idiomas",
                      owner: ClassOwnerModel(
                        id: userViewModel.user?.id ?? "",
                        name: userViewModel.user?.name ?? "",
                      ),
                    );

                    final ClassModel? classCreated =
                        await classManagementViewModel.createClass(classModel);

                    if (classCreated != null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Turma criada com sucesso!",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: cColorSuccess,
                      ));
                    } else if (classManagementViewModel.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          classManagementViewModel.error!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: cColorError,
                      ));
                    }
                  },
                  child: classManagementViewModel.isLoading
                      ? const LoadingWidget(
                          color: cColorPrimary,
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Criar turma"),
                        )),
              // TESTANDO A BUSCA DE TURMAS
              OutlinedButton(
                onPressed: () async {
                  if (userViewModel.user!.classes.isNotEmpty) {
                    final ClassModel? classGet = await classManagementViewModel
                        .getClass(userViewModel.user!.classes[0]["id"]!);

                    if (classGet != null) {
                      print(classGet.toJson());
                    }

                    if (classManagementViewModel.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          classManagementViewModel.error!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        backgroundColor: cColorError,
                      ));
                    }
                  }
                },
                child: classManagementViewModel.isLoading
                    ? const LoadingWidget(
                        color: cColorPrimary,
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Pegar informações da sua primeira turma"),
                      ),
              ),
              // TESTANDO A INSCRIÇÃO EM TURMAS
              OutlinedButton(
                onPressed: () async {
                  final result = await classManagementViewModel.joinClass("?");

                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Você entrou na turma com sucesso!",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: cColorSuccess,
                    ));
                  } else if (classManagementViewModel.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        classManagementViewModel.error!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: cColorError,
                    ));
                  }
                },
                child: classManagementViewModel.isLoading
                    ? const LoadingWidget(
                        color: cColorPrimary,
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Inscrever-se em uma turma"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
