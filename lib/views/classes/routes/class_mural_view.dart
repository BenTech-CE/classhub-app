import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/mural_type.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/mural/author_model.dart';
import 'package:classhub/models/class/mural/create_post_mural_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:classhub/viewmodels/class/mural/class_mural_viewmodel.dart';
import 'package:classhub/views/classes/widgets/new_post_widget.dart';
import 'package:classhub/views/classes/widgets/post_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassMuralView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassMuralView({super.key, required this.mClassObj});

  @override
  State<ClassMuralView> createState() => _ClassMuralViewState();
}

class _ClassMuralViewState extends State<ClassMuralView> {
  Set<String> muralSelectedOption = {};

  late MaterialColor classColor;

  late Future<List<MuralModel>> _muralFuture;

  Future<List<MuralModel>> _fetchMural() async {
    final cmvm = context.read<ClassMuralViewModel>();
    return await cmvm.getPostsDoNotNotify(widget.mClassObj.id, 1);
  }

  @override
  void initState() {
    super.initState();

    classColor = generateMaterialColor(Color(widget.mClassObj.color));

    _muralFuture = _fetchMural();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NewPostWidget(
            classColor: classColor,
            classId: widget.mClassObj.id,
          ),
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
            alignment: Alignment.topCenter,
            child: FutureBuilder<List<MuralModel>>(
              future: _muralFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  print(snapshot.stackTrace);
                  print(snapshot.error);

                  return Text(
                    'Ocorreu um erro: ${snapshot.error}',
                  );
                }

                if (snapshot.hasData) {
                  final posts = snapshot.data!;
                  print(posts.length);

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: posts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      if (posts[index].type == MuralType.AVISO) {
                        return PostAlertWidget(
                            classColor: classColor, post: posts[index]);
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 16);
                    },
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
