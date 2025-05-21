import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:flutter/material.dart';

class ClassMuralView extends StatefulWidget {
  final MinimalClassModel classObj;

  const ClassMuralView({super.key, required this.classObj});

  @override
  State<ClassMuralView> createState() => _ClassMuralViewState();
}

class _ClassMuralViewState extends State<ClassMuralView> {
  String muralSelectedOption = "avisos";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: sPadding),
          SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
                selectedBackgroundColor: cColorAzulSecondary,
                selectedForegroundColor: cColorPrimary,
                foregroundColor: cColorPrimary,
                side: const BorderSide(color: cColorAzulSecondary, width: 1)
            ),
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: "avisos",
                label: Text('Avisos'),
              ),
              ButtonSegment<String>(
                value: "materiais",
                label: Text('Materiais'),
              ),
            ],
            selected: <String>{muralSelectedOption},
            showSelectedIcon: false,
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                // By default there is only a single segment that can be
                // selected at one time, so its value is always the first
                // item in the selected set.
                muralSelectedOption = newSelection.first;
              });
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(sPadding),
              physics: AlwaysScrollableScrollPhysics(),
              children: [0,1,2,3,4,5,6,7,8,9].map((e) => 
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(sPadding3),
                      alignment: Alignment.centerLeft,
                      width: double.maxFinite,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: cColorText2Azul),
                        borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: Text("Aviso $e"),
                    ),
                    const SizedBox(height: sSpacing)
                  ],
                )
              ).toList(),
            ),
          ),
        ]
      ),
    );
  }
}
