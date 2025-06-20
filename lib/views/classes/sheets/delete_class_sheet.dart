
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class DeleteClassSheet extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const DeleteClassSheet({super.key, required this.mClassObj});

  @override
  State<DeleteClassSheet> createState() => _DeleteClassSheetState();
}

class _DeleteClassSheetState extends State<DeleteClassSheet> {
  final _titleConfirmationTF = TextEditingController();
  final _titleConfirmationFocus = FocusNode();

  // Ação de quando clicar no botão de deletar a turma
  void _btnDelete(BuildContext ctx) async {
    if (_titleConfirmationTF.text != widget.mClassObj.name) {
      _titleConfirmationFocus.requestFocus();
      return;
    }
    final userViewModel = ctx.read<UserViewModel>();
    final classManagementViewModel = ctx.read<ClassManagementViewModel>();

    final result =
        await classManagementViewModel.deleteClass(widget.mClassObj.id);
    if (result) {
      await userViewModel.fetchUser();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Turma deletada com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (classManagementViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          classManagementViewModel.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _titleConfirmationFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassManagementViewModel classManagementViewModel =
        context.watch<ClassManagementViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + sPadding3),
          child: Container(
              // height: 510,
              // constraints: new BoxConstraints(minHeight: 510, maxHeight: 600),
              padding: const EdgeInsets.symmetric(horizontal: sPadding3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sSpacing,
                children: [
                  Text("Deletar Turma",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: cColorPrimary),
                      textAlign: TextAlign.center),
                  Text(
                      "Tem certeza que deseja deletar ${widget.mClassObj.name}?",
                      style: AppTextTheme.placeholder
                          .copyWith(color: cColorTextAzul),
                      textAlign: TextAlign.start),
                  Text(
                      "Digite na caixa de texto de Confirmação “${widget.mClassObj.name}”",
                      style: AppTextTheme.placeholder
                          .copyWith(color: Colors.black54),
                      textAlign: TextAlign.start),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Confirmação",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: cColorTextAzul),
                            textAlign: TextAlign.start),
                        TextField(
                          controller: _titleConfirmationTF,
                          focusNode: _titleConfirmationFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: const RoundedColoredInputBorder(),
                              enabledBorder: const RoundedColoredInputBorder(),
                              hintText: widget.mClassObj.name,
                              hintStyle: const TextStyle(
                                  fontFamily: "Onest",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: cColorText2Azul)),
                        ),
                      ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const HugeIcon(
                        icon: HugeIcons.strokeRoundedAlert02,
                        color: cColorWarning),
                    const SizedBox(width: 5.0),
                    Expanded(
                      child: Text(
                        "Aviso: Deletar uma turma é uma ação irreversível!",
                        style: AppTextTheme.placeholder,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ]),
                  ElevatedButton(
                    child: classManagementViewModel.isLoading
                        ? const LoadingWidget()
                        : const Text("Deletar"),
                    onPressed: () => _btnDelete(context),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
