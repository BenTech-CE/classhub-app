import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/theme.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/auth/login/login_view.dart';
import 'package:classhub/views/classes/class_view.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectCard extends StatefulWidget {
  final SubjectModel subject;
  const SubjectCard({Key? key, required this.subject});

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {

  late MaterialColor color;

  @override
  void initState() {
    super.initState();

    color = generateMaterialColor(Color(widget.subject.color??0));
  }

  @override
  Widget build(BuildContext context) {
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

    return ExpandablePanel(
      collapsed: Container(
        height: 70,
        decoration: BoxDecoration(
          color: color.shade100
        ),
      ),
      expanded: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.amber
        ),
      ),
    );
  }
}