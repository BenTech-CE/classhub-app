import 'package:classhub/core/theme/colors.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 20.0,
      children: [
        SegmentedButton<String>(
          style: SegmentedButton.styleFrom(
              selectedBackgroundColor: cColorAzulSecondary,
              selectedForegroundColor: cColorPrimary,
              foregroundColor: cColorPrimary,
              side: const BorderSide(color: cColorAzulSecondary, width: 1)),
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
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              // By default there is only a single segment that can be
              // selected at one time, so its value is always the first
              // item in the selected set.
              muralSelectedOption = newSelection.first;
            });
          },
        ),
        Text('ID: ${widget.classObj.id}'),
      ]
    );
  }
}
