import 'dart:convert';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/subjects/schedule_weekday_model.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/views/classes/routes/sheets/create_subject_sheet.dart';
import 'package:classhub/views/user/widgets/subject_card.dart';
import 'package:flutter/material.dart';

class ClassSubjectsView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassSubjectsView({super.key, required this.mClassObj});

  @override
  State<ClassSubjectsView> createState() => _ClassSubjectsViewState();
}

class _ClassSubjectsViewState extends State<ClassSubjectsView> {

  late MaterialColor classColor;

  SubjectModel materiafake = SubjectModel.fromJson({
      "id": "008f56bb-5c8e-4974-9352-bd569e0d1894",
      "title": "Português II",
      "teacher": "Janieyre",
      "pud": "https://www.google.com",
      "class_id": "f9639c2f-f1d3-4a81-986c-200e51299e6a",
      "schedule": {
          "sunday": null,
          "monday": {
              "start_time": "13:30",
              "end_time": "15:30",
              "location": "BC 12"
          },
          "wednesday": null,
          "tuesday": null,
          "thursday": null,
          "friday": null,
          "saturday": null
      },
      "color": 4280521466
  });

  SubjectModel materiafake2 = SubjectModel.fromJson({
      "id": "008f56bb-5c8e-4974-9352-bd569e0d1894",
      "title": "Programação Web I",
      "teacher": "José Roberto",
      "pud": "https://www.google.com",
      "class_id": "f9639c2f-f1d3-4a81-986c-200e51299e6a",
      "schedule": {
          "sunday": null,
          "monday": null,
          "wednesday": null,
          "tuesday": {
              "start_time": "13:30",
              "end_time": "15:30",
              "location": "LMC4"
          },
          "thursday": {
              "start_time": "13:30",
              "end_time": "15:30",
              "location": "LMC4"
          },
          "friday": null,
          "saturday": null
      },
      "color": Color.fromARGB(255, 240, 65, 243).toARGB32()
  });

  SubjectModel materiafake3 = SubjectModel.fromJson({
      "id": "008f56bb-5c8e-4974-9352-bd569e0d1894",
      "title": "Matemática VI",
      "teacher": "Kiara",
      "pud": "https://www.google.com",
      "class_id": "f9639c2f-f1d3-4a81-986c-200e51299e6a",
      "schedule": {
          "sunday": null,
          "monday": null,
          "wednesday": {
              "start_time": "13:30",
              "end_time": "15:30",
              "location": "BC 48"
          },
          "tuesday": null,
          "thursday": null,
          "friday": null,
          "saturday": null
      },
      "color": Color.fromARGB(255, 250, 90, 16).toARGB32()
  });

  void _sheetCreateSubject(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => const CreateSubjectSheet(),
    );
  }

  @override
  void initState() {
    super.initState();
    classColor = generateMaterialColor(Color(widget.mClassObj.color));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(sPadding),
                  child: Column(
                    spacing: sSpacing,
                    children: [
                      SubjectCard(mClassObj: widget.mClassObj, subject: materiafake),
                      SubjectCard(mClassObj: widget.mClassObj, subject: materiafake2),
                      SubjectCard(mClassObj: widget.mClassObj, subject: materiafake3)
                    ]
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
