import 'dart:convert';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/models/class/subjects/schedule_weekday_model.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:classhub/widgets/ui/weekday_card.dart';
import 'package:classhub/widgets/ui/weekday_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class EditSubjectSheet extends StatefulWidget {
  final SubjectModel subjObj;
  final String classId;
  final int classColor;
  final Function(SubjectModel) onSubjectCreated; 

  const EditSubjectSheet({super.key, required this.subjObj, required this.classId, required this.classColor, required this.onSubjectCreated});

  @override
  State<EditSubjectSheet> createState() => _EditSubjectSheetState();
}

class _EditSubjectSheetState extends State<EditSubjectSheet> {
  final _titleTF = TextEditingController();
  final _teacherTF = TextEditingController();

  Color currentColor = Color(4280521466);

  SubjectModel subject = SubjectModel(id: "", title: "", schedule: <String, ScheduleWeekday?>{
    "sunday": null,
    "monday": null,
    "tuesday": null,
    "wednesday": null,
    "thursday": null,
    "friday": null,
    "saturday": null
  });

  void _handleSubjectUpdate() {
    setState(() {
      // O objeto 'subject' já foi modificado pelo weekday_select.dart
      // Apenas chamamos setState para informar ao Flutter que a UI precisa ser reconstruída.
    });

    print(jsonEncode(subject.schedule));
  }

  void _btnCreate(BuildContext context) async {
    setState(() {
      subject.title = _titleTF.text;
      subject.teacher = _teacherTF.text;
      subject.color = currentColor.toARGB32();
    });

    if (subject.schedule.entries.where((entry) => entry.value != null).isEmpty) return; // Alertar

    //final userViewModel = context.read<UserViewModel>();
    final subjectViewModel = context.read<ClassSubjectsViewModel>();

    SubjectModel? result = await subjectViewModel.editSubject(widget.classId, subject);

    if (result != null) {
      widget.onSubjectCreated(result);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Matéria editada com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));

      Navigator.of(context).pop();
    } else if (subjectViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          subjectViewModel.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      //Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pop(context);
    }
  }

  void _colorPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text('Selecione uma cor'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: currentColor,
              availableColors: listOfClassColors,
              onColorChanged: (color) {
                setState(() {
                  currentColor = color;
                  subject.color = color.toARGB32();
                });

                Navigator.of(ctx).pop();
              },
            ),
          )),
    );
  }

  @override void initState() {
    super.initState();

    currentColor = Color(widget.subjObj.color!);
    _titleTF.text = widget.subjObj.title;
    _teacherTF.text = widget.subjObj.teacher!;

    setState(() {
      subject.schedule = widget.subjObj.schedule;
      subject.pud = widget.subjObj.pud;
      subject.id = widget.subjObj.id;
    });
  }

  @override void dispose() {
    super.dispose();
    _titleTF.dispose();
    _teacherTF.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassSubjectsViewModel subjectsViewModel =
        context.watch<ClassSubjectsViewModel>();

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + sPadding3),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: sPadding3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: sSpacing,
                  children: [
                    Text("Editar Matéria",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: cColorPrimary),
                        textAlign: TextAlign.center),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Título",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: cColorTextAzul),
                              textAlign: TextAlign.start),
                          TextField(
                            controller: _titleTF,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                border: RoundedColoredInputBorder(),
                                enabledBorder: RoundedColoredInputBorder(),
                                hintText: "Ex.: Português I",
                                hintStyle: TextStyle(
                                    fontFamily: "Onest",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0,
                                    color: cColorText2Azul)),
                          ),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Professor(a)",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: cColorTextAzul),
                              textAlign: TextAlign.start),
                          TextField(
                            controller: _teacherTF,
                            //focusNode: _titleFocus,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                border: const RoundedColoredInputBorder(),
                                enabledBorder: const RoundedColoredInputBorder(),
                                hintText: "Ex.: Maria da Silva",
                                hintStyle: AppTextTheme.placeholder),
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cor de destaque",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: cColorTextAzul),
                              textAlign: TextAlign.start),
                          GestureDetector(
                            onTap: () => _colorPicker(),
                            child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  Image.asset("assets/images/rainbow.png",
                                      width: 45, height: 45),
                                  Container(
                                    width: 37,
                                    height: 37,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: currentColor,
                                    ),
                                  ),
                                  const HugeIcon(
                                    icon: HugeIcons.strokeRoundedPaintBoard,
                                    color: Colors.white,
                                    size: 29,
                                  )
                                ]),
                          )
                        ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 5,
                    children: [
                      Text("Dias de encontro",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: cColorTextAzul),
                          textAlign: TextAlign.start),
                      WeekdaySelect(subject: subject, onSubjectChanged: _handleSubjectUpdate,),
                      ...subject.schedule.entries
                        .where((entry) => entry.value != null)
                        .map((entry) => WeekdayCard(
                            subject: subject,
                            onSubjectChanged: _handleSubjectUpdate,
                            weekday: entry.key,
                          ))
                    ]),
                    
                    ElevatedButton(
                      child: subjectsViewModel.isLoading
                          ? const LoadingWidget()
                          : const Text("Editar Matéria"),
                      onPressed: () => _btnCreate(context),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}