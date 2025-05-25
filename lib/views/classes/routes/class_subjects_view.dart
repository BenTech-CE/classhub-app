import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/views/classes/routes/sheets/create_subject_sheet.dart';
import 'package:flutter/material.dart';

class ClassSubjectsView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassSubjectsView({super.key, required this.mClassObj});

  @override
  State<ClassSubjectsView> createState() => _ClassSubjectsViewState();
}

class _ClassSubjectsViewState extends State<ClassSubjectsView> {

  late MaterialColor classColor;

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
                    children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                        .map((e) => Container(
                              padding: EdgeInsets.all(sPadding3),
                              alignment: Alignment.centerLeft,
                              width: double.maxFinite,
                              height: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(color: cColorText2Azul),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Text("Matéria $e"),
                            ))
                        .toList(),
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
