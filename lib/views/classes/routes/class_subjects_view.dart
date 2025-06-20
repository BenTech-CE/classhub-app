import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
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

  bool _loading = false;

  void _sheetCreateSubject(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => CreateSubjectSheet(classId: widget.mClassObj.id, classColor: widget.mClassObj.color, onSubjectCreated: () => _fetchSubjects(context),),
    );
  }

  void _handleEdit(SubjectModel sbj) async {
    /*int idx = subjects.indexWhere((s) => s.id == sbj.id);

    if (idx != -1) {
      subjects[idx] = sbj;
    }

    print("updated subject: ${sbj.title}");*/
    _loading = true;

    final subjectViewModel = context.read<ClassSubjectsViewModel>();

    final fetched = await subjectViewModel.getSubjects(widget.mClassObj.id, changeLoadingState: true);
    fetched.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    
    setState(() {
      subjects = fetched;
      _loading = false;
    });
  }

  void _handleDel(String id) {
    int idx = subjects.indexWhere((s) => s.id == id);

    if (idx != -1) {
      subjects.removeAt(idx);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
        content: Text(
          "Matéria deletada com sucesso!",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));
    }

    setState(() {
      
    });
  }

  Future<void> _fetchSubjects(BuildContext context) async {
    setState(() {
      _loading = true;
    });

    final subjectViewModel = context.read<ClassSubjectsViewModel>();

    final cached = subjectViewModel.getCachedSubjects(widget.mClassObj.id);
    cached.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    setState(() {
      subjects = cached;
      _loading = false;
    });

    final fetched = await subjectViewModel.getSubjects(widget.mClassObj.id, changeLoadingState: false);
    fetched.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

    if (mounted) {
      setState(() {
        subjects.clear();
      });

      setState(() {
        subjects = fetched;
      });
    }
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
    //final subjectViewModel = context.watch<ClassSubjectsViewModel>();

    return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(sPadding),
                  child: _loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: sSpacing,
                        children: [
                          Text(
                            "Aguarde enquanto carregamos as matérias...",
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: sSpacing),
                          const LoadingWidget(
                            color: cColorPrimary,
                          ),
                        ],
                      )
                    : Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), 
                          separatorBuilder: (context, index) => const SizedBox(height: sSpacing),
                          itemCount: subjects.length,
                          itemBuilder: (context, index) {
                            final sbj = subjects[index];
                            return SubjectCard(
                              key: ValueKey(sbj.id),
                              mClassObj: widget.mClassObj,
                              subject: sbj,
                              onEdited: _handleEdit,
                              onDeleted: () => _handleDel(sbj.id),
                            );
                          },
                        ),
                        if (widget.mClassObj.role >= Role.viceLider)
                          const SizedBox(
                            height: 64,
                          )
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
