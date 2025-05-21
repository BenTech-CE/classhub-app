import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/classes/class_view.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinClassSheet extends StatefulWidget {
  const JoinClassSheet({super.key});

  @override
  State<JoinClassSheet> createState() => _JoinClassSheetState();
}

class _JoinClassSheetState extends State<JoinClassSheet> {
  final _inviteCodeTF = TextEditingController();

  void _btnEntrar(ctx) async {
    final classManagementViewModel = ctx.read<ClassManagementViewModel>();

    if (_inviteCodeTF.text.isNotEmpty) {
      final result = await classManagementViewModel.joinClass(_inviteCodeTF.text);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Você entrou na turma com sucesso!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ClassView(classObj: )))
    }
  }

  @override
  void dispose() {
    super.dispose();
    _inviteCodeTF.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassManagementViewModel classManagementViewModel =
        context.watch<ClassManagementViewModel>();

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 210,
          padding: const EdgeInsets.symmetric(horizontal: sPadding3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: sSpacing,
            children: [
              Text("Entrar em turma existente",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text("Código da Turma",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: cColorTextAzul),
                    textAlign: TextAlign.start),
                TextField(
                  controller: _inviteCodeTF,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: const InputDecoration(
                      border: RoundedColoredInputBorder(),
                      enabledBorder: RoundedColoredInputBorder(),
                      hintText: "Ex.: 123456",
                      hintStyle: TextStyle(
                          fontFamily: "Onest",
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: cColorText2Azul)),
                ),
              ]),
              ElevatedButton(
                child: classManagementViewModel.isLoading
                    ? const LoadingWidget(
                        color: cColorPrimary,
                      )
                    : const Text("Entrar na Turma"),
                onPressed: () => _btnEntrar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
