import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/views/classes/widgets/new_post_widget.dart';
import 'package:flutter/material.dart';

class ClassMuralView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassMuralView({super.key, required this.mClassObj});

  @override
  State<ClassMuralView> createState() => _ClassMuralViewState();
}

class _ClassMuralViewState extends State<ClassMuralView> {
  Set<String> muralSelectedOption = {  };

  late MaterialColor classColor;

  Future<void> _fetchMural() {
    return Future.delayed(Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();

    classColor = generateMaterialColor(Color(widget.mClassObj.color));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _fetchMural(),
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NewPostWidget(classColor: classColor),
            SegmentedButton<String>(
              style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: classColor.shade400,
                  selectedForegroundColor: Colors.white,
                  foregroundColor: classColor.shade800,
                  side: BorderSide(color: classColor.shade300, width: 1)),
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
              selected: muralSelectedOption,
              showSelectedIcon: false,
              multiSelectionEnabled: false,
              emptySelectionAllowed: true,
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  // By default there is only a single segment that can be
                  // selected at one time, so its value is always the first
                  // item in the selected set.
                  try {
                    muralSelectedOption = newSelection;
                  } catch (_) {
                    muralSelectedOption = {};
                  }
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(sPadding),
              child: Column(
                spacing: sSpacing,
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                    .map((e) => Container(
                          padding: EdgeInsets.all(sPadding3),
                          alignment: Alignment.centerLeft,
                          width: double.maxFinite,
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: cColorText2Azul),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          child: Text("Aviso $e"),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
