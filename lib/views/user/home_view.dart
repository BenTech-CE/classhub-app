import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/class_owner_model.dart';
import 'package:classhub/viewmodels/auth/auth_viewmodel.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/classes/class_view.dart';
import 'package:classhub/views/classes/sheets/create_class_sheet.dart';
import 'package:classhub/views/classes/sheets/create_or_join_sheet.dart';
import 'package:classhub/views/classes/sheets/join_class_sheet.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
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
    final classManagementViewModel = context.watch<ClassManagementViewModel>();

    final popupMenuItemsOwner = [
      const PopupMenuItem<String>(
        value: 'edit',
        child: Text('Editar turma'),
      ),
      const PopupMenuItem<String>(value: 'delete', child: Text('Deletar turma'))
    ];

    final popupMenuItemsLeader = [
      const PopupMenuItem<String>(
        value: 'edit',
        child: Text('Editar turma'),
      ),
      const PopupMenuItem<String>(
        value: 'leave',
        child: Text('Sair da turma'),
      )
    ];

    final popupMenuItemsMember = [
      const PopupMenuItem<String>(
        value: 'leave',
        child: Text('Sair da turma'),
      )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Suas Turmas"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _sheetCreateOrJoinClass(context);
          },
          shape: const CircleBorder(),
          backgroundColor: cColorPrimary,
          child: const Icon(Icons.add)),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
                sPadding, sPadding, sPadding, sPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.0,
              children: [
                // Verificamos se o usuário tem turmas ai mapeamos cada turma para uma instância de Card de Turma (figma)
                (userViewModel.user != null &&
                        userViewModel.user!.classes.isNotEmpty)
                    ? Column(
                        spacing: 20.0,
                        children: userViewModel.user!.classes.map((turma) {
                          return SizedBox(
                              width: double.maxFinite,
                              height: 150,
                              child: ElevatedButton(
                                  style: AppTheme
                                      .theme.elevatedButtonTheme.style
                                      ?.copyWith(
                                    padding: const WidgetStatePropertyAll(
                                        EdgeInsets.all(0.0)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Color(turma.color)),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClassView(classObj: turma)));
                                  },
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(sBorderRadius)),
                                      child: Stack(
                                        children: [
                                          turma.bannerUrl != null
                                              ? Stack(
                                                  children: [
                                                    Image.network(
                                                      turma.bannerUrl!,
                                                      width: double.maxFinite,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Container(
                                                      width: double.maxFinite,
                                                      height: 150,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end: Alignment
                                                              .topCenter,
                                                          colors: [
                                                            Color(turma.color),
                                                            Colors.transparent,
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(
                                                  width: double.maxFinite,
                                                  height: 150,
                                                  color: Color(turma.color)),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        PopupMenuButton<String>(
                                                          icon: const Icon(
                                                              Icons.more_vert,
                                                              size: 24.0),
                                                          onSelected:
                                                              (String value) async {
                                                            if (value ==
                                                                'edit') {
                                                              // Edit action
                                                            } else if (value ==
                                                                'leave') {
                                                              // Leave action
                                                            } else if (value ==
                                                                'delete') {
                                                              final result =
                                                                  await classManagementViewModel.deleteClass(turma.id);
                                                              if (result) {
                                                                await _userInfo(context);
                                                                ScaffoldMessenger.of(context)
                                                                    .showSnackBar(const SnackBar(
                                                                  content: Text(
                                                                    "Turma deletada com sucesso!",
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  backgroundColor: cColorSuccess,
                                                                ));
                                                              } else if (classManagementViewModel.error != null) {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text(
                                                                    classManagementViewModel.error!,
                                                                    style: const TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                  backgroundColor: cColorError,
                                                                ));
                                                              }
                                                            }
                                                          },
                                                          itemBuilder: (BuildContext
                                                                  context) =>
                                                              turma.role ==
                                                                      Role.lider
                                                                  ? popupMenuItemsOwner
                                                                  : popupMenuItemsMember,
                                                          // atention: Offset de onde irá aparecer o menu (x, y)
                                                          offset: const Offset(
                                                              -24, 24),
                                                        )
                                                      ]),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(turma.name,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge
                                                                  ?.copyWith(
                                                                      fontSize:
                                                                          24.0,
                                                                      color:
                                                                          cColorTextWhite)),
                                                          Text(turma.school,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge
                                                                  ?.copyWith(
                                                                      fontSize:
                                                                          16.0,
                                                                      color:
                                                                          cColorTextWhite)),
                                                        ]),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ))));
                        }).toList(),
                      )
                    : const Text("Sem turmas para mostrar."),
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
                          await classManagementViewModel
                              .createClass(classModel);

                      if (classCreated != null) {
                        // sync alterações
                        await _userInfo(context);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Turma criada com sucesso!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: cColorSuccess,
                        ));
                      } else if (classManagementViewModel.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            classManagementViewModel.error!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                      final ClassModel? classGet =
                          await classManagementViewModel
                              .getClass(userViewModel.user!.classes[0].id);

                      if (classGet != null) {
                        print(classGet.inviteCode);
                      }

                      if (classManagementViewModel.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            classManagementViewModel.error!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                          child:
                              Text("Pegar informações da sua primeira turma"),
                        ),
                ),
                // TESTANDO A INSCRIÇÃO EM TURMAS
                OutlinedButton(
                  onPressed: () async {
                    final result =
                        await classManagementViewModel.joinClass("?");

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
                // Botão Sair da Conta (sign out)
                OutlinedButton(
                    onPressed: () {
                      authViewModel.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginView()));
                    },
                    child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text("Sair da Conta"))),
                Text("Bem-vindo, ${userViewModel.user?.name}!",
                    style: Theme.of(context).textTheme.labelLarge),
                Text(
                    "Você está em ${userViewModel.user?.classes.length} turmas.",
                    style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
