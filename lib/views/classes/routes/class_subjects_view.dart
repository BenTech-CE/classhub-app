import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:flutter/material.dart';

class ClassSubjectsView extends StatefulWidget {
  const ClassSubjectsView({super.key});

  @override
  State<ClassSubjectsView> createState() => _ClassSubjectsViewState();
}

class _ClassSubjectsViewState extends State<ClassSubjectsView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
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
    );
  }
}
