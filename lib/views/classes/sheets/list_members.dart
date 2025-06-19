import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/views/classes/sheets/create_class_sheet.dart';
import 'package:classhub/views/classes/sheets/join_class_sheet.dart';
import 'package:classhub/views/classes/widgets/member_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/colors.dart';

class ListMembersSheet extends StatefulWidget {
  const ListMembersSheet({super.key});

  @override
  State<ListMembersSheet> createState() => _ListMembersSheetState();
}

class _ListMembersSheetState extends State<ListMembersSheet> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(sPadding),
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
              "Mostrando 4 colegas em P5 - Informática",
              style: TextStyle(color: cColorText2Azul),
              textAlign: TextAlign.left,
            ), // se quiser espaço entre os textos e a lista
            Expanded(
              // solução do problema
              child: ListView(
                padding: EdgeInsets.all(0),
                children: const [
                  MemberCardWidget(name: "João Gabriel", role: "Líder", color: Colors.pink,),
                  MemberCardWidget(name: "Ismael Lira Nascimento Lira Lira Lira Lira Lira Lira Lira Lira Lira Lira Lira Lira Lira ", role: "Vice-Líder", color: Colors.green,),
                  MemberCardWidget(name: "Yasmin Sousa", role: "Colega", color: Colors.blueGrey,),
                  MemberCardWidget(name: "Kauã Sousa", role: "Colega", color: Colors.deepOrange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
