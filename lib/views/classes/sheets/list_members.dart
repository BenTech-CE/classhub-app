import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/class_member_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/views/classes/sheets/create_class_sheet.dart';
import 'package:classhub/views/classes/sheets/join_class_sheet.dart';
import 'package:classhub/views/classes/widgets/member_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/colors.dart';

class ListMembersSheet extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ListMembersSheet({super.key, required this.mClassObj});

  @override
  State<ListMembersSheet> createState() => _ListMembersSheetState();
}

class _ListMembersSheetState extends State<ListMembersSheet> {
  final _membersList = [
    ClassMemberModel.fromJson({
      "id": "uuid-do-lider-1",
      "name": "João Gabriel Aguiar",
      "profile_picture": null,
      "role": 5
    },),
    ClassMemberModel.fromJson({
      "id": "uuid-do-lider-2",
      "name": "Kauã Sousa",
      "profile_picture": null,
      "role": 4
    },),
    ClassMemberModel.fromJson({
      "id": "uuid-do-3",
      "name": "Ismael Lira",
      "profile_picture": null,
      "role": 0
    },)
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: sSpacing,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: sPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: sSpacing,
              children: [
                Text(
                  "Lista de Colegas", 
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Mostrando ${_membersList.length} colegas em P5 - Informática",
                  style: TextStyle(color: cColorText2Azul),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ), // se quiser espaço entre os textos e a lista
          Expanded(
            // solução do problema
            child: ListView(
              children: _membersList.map(
                (member) => MemberCardWidget(
                  member: member, 
                  color: generateMaterialColor(cColorPrimary),
                  myRole: widget.mClassObj.role
                ),
              ).toList(),
            ),
          ),
        ],
      )
    );
  }
}
