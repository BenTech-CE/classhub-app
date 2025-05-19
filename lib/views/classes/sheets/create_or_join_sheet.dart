import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/views/classes/sheets/create_class_sheet.dart';
import 'package:classhub/views/classes/sheets/join_class_sheet.dart';
import 'package:flutter/material.dart';

class CreateOrJoinSheet extends StatefulWidget {
  const CreateOrJoinSheet({super.key});

  @override
  State<CreateOrJoinSheet> createState() => _CreateOrJoinSheetState();
}

class _CreateOrJoinSheetState extends State<CreateOrJoinSheet> {
  void _sheetCreateClass(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => const CreateClassSheet(),
    );
  }

  void _sheetJoinClass(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => const JoinClassSheet()
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.18,
      initialChildSize: 0.18,
      maxChildSize: 0.25,
      expand: false,
      builder: (_, controller) => Container(
          padding: const EdgeInsets.symmetric(horizontal: sPadding3),
          child: ListView(
            controller: controller,
            children: <Widget>[
              OutlinedButton(
                child: const Text('Entrar em turma existente'),
                onPressed: () => _sheetJoinClass(context),
              ),
              const SizedBox(height: sSpacing),
              ElevatedButton(
                child: const Text('Criar nova turma'),
                onPressed: () => _sheetCreateClass(context),
              ),
            ],
          )),
    );
  }
}
