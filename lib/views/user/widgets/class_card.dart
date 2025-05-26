import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/viewmodels/class/members/class_management_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/classes/class_view.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassCard extends StatefulWidget {
  final MinimalClassModel turma;
  const ClassCard({Key? key, required this.turma}) : super(key: key);

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> {
  bool loadingLeave = false;
  bool loadingDelete = false;

  @override
  Widget build(BuildContext context) {
    final ClassManagementViewModel classManagementViewModel =
        context.watch<ClassManagementViewModel>();
    final ClassMembersViewModel classMembersViewModel =
        context.watch<ClassMembersViewModel>();
    final UserViewModel userViewModel = context.watch<UserViewModel>();
    final MinimalClassModel turma = widget.turma;

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

    return SizedBox(
      height: 150,
      child: ElevatedButton(
        style: AppTheme.theme.elevatedButtonTheme.style?.copyWith(
          padding: const WidgetStatePropertyAll(EdgeInsets.all(0.0)),
          backgroundColor: WidgetStatePropertyAll(Color(turma.color)),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ClassView(mClassObj: turma)));
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(sBorderRadius)),
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
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
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
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 24.0),
                        onSelected: (String value) async {
                          if (value == 'edit') {
                            // Edit action
                          } else if (value == 'leave') {
                            loadingLeave = true;
                            setState(() {});

                            final result = await classMembersViewModel
                                .deleteMember(turma.id, userViewModel.user!.id);
                            if (result) {
                              await userViewModel.fetchUser();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  "Você saiu da turma com sucesso!",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: cColorSuccess,
                              ));
                              loadingLeave = false;
                              setState(() {});
                            } else if (classManagementViewModel.error != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  classManagementViewModel.error!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: cColorError,
                              ));
                              loadingLeave = false;
                              setState(() {});
                            }
                          } else if (value == 'delete') {
                            loadingDelete = true;
                            setState(() {});
                            final result = await classManagementViewModel
                                .deleteClass(turma.id);
                            if (result) {
                              await userViewModel.fetchUser();
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
                              loadingDelete = false;
                              setState(() {});
                            } else if (classManagementViewModel.error != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  classManagementViewModel.error!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: cColorError,
                              ));
                              loadingDelete = false;
                              setState(() {});
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            turma.role == Role.lider
                                ? popupMenuItemsOwner
                                : popupMenuItemsMember,
                        // atention: Offset de onde irá aparecer o menu (x, y)
                        offset: const Offset(-24, 24),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(turma.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontSize: 24.0, color: cColorTextWhite)),
                          Text(turma.school,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                      fontSize: 16.0, color: cColorTextWhite)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (loadingLeave || loadingDelete)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.black.withOpacity(0.5),
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: LoadingWidget(),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            loadingLeave
                                ? "Saindo da turma"
                                : loadingDelete
                                    ? "Deletando turma"
                                    : "",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    fontSize: 16.0, color: cColorTextWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
