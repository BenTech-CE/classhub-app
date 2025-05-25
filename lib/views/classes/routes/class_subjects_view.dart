import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
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
      "teacher": "Jane",
      "pud": null,
      "class_id": "f9639c2f-f1d3-4a81-986c-200e51299e6a",
      "schedule": {
          "sunday": null,
          "monday": {
              "start_time": "13:30",
              "end_time": "15:39",
              "location": "BC 12"
          },
          "tuesday": null,
          "wednesday": null,
          "thursday": null,
          "friday": null,
          "saturday": null
      },
      "color": 4280521466
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
                      SubjectCard(subject: materiafake)
                    ]
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16.0, // Distância da direita
            bottom: 16.0, // Distância de baixo
            child: FloatingActionButton(
              onPressed: () => _sheetCreateSubject(context),
              shape: const CircleBorder(),
              backgroundColor: classColor,
              child: const Icon(Icons.add),
            ),
          ),
        ],
    );
  }
}
