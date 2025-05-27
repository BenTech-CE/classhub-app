import 'dart:convert';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/subjects/schedule_weekday_model.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/views/classes/routes/sheets/create_subject_sheet.dart';
import 'package:classhub/views/user/widgets/subject_card.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassSubjectsView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassSubjectsView({super.key, required this.mClassObj});

  @override
  State<ClassSubjectsView> createState() => _ClassSubjectsViewState();
}

class _ClassSubjectsViewState extends State<ClassSubjectsView> {

  late MaterialColor classColor;

  List<SubjectModel> subjects = [];

  void _sheetCreateSubject(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => CreateSubjectSheet(classId: widget.mClassObj.id, onSubjectCreated: () => _fetchSubjects(context),),
    );
  }

  Future<void> _fetchSubjects(BuildContext context) async {
    final subjectViewModel = context.read<ClassSubjectsViewModel>();

    subjects = await subjectViewModel.getSubjects(widget.mClassObj.id);
  }

  @override
  void initState() {
    super.initState();
    classColor = generateMaterialColor(Color(widget.mClassObj.color));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchSubjects(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectViewModel = context.watch<ClassSubjectsViewModel>();

    return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(sPadding),
                  child: Column(
                    spacing: sSpacing,
                    children: subjectViewModel.isLoading ? [
                          Text("Aguarde enquanto carregamos as matérias...",
                              style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
                          const LoadingWidget(
                            color: cColorPrimary,
                          ),
                    ] : [
                      ...subjects.map((sbj) => SubjectCard(mClassObj: widget.mClassObj, subject: sbj))
                    ],
                  ),
                ),
              ],
            ),
          ),
          widget.mClassObj.role >= Role.viceLider ? Positioned(
            right: 16.0, // Distância da direita
            bottom: 16.0, // Distância de baixo
            child: FloatingActionButton(
              onPressed: () => _sheetCreateSubject(context),
              shape: const CircleBorder(),
              backgroundColor: classColor,
              child: const Icon(Icons.add),
            ),
          ) : Container(),
        ],
    );
  }
}
