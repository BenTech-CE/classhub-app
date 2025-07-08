import 'package:auto_size_text/auto_size_text.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/views/classes/routes/sheets/edit_subject_sheet.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class SubjectCard extends StatefulWidget {
  final SubjectModel subject;
  final MinimalClassModel mClassObj;
  final Function(SubjectModel) onEdited;
  final VoidCallback onDeleted;

  const SubjectCard({Key? key, required this.mClassObj, required this.subject, required this.onEdited, required this.onDeleted});

  @override
  _SubjectCardState createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  final collapsedHeight = 60.0;

  late MaterialColor color;

  late List<Map<String, dynamic>> groupedSchedule;
  late List<Map<String, dynamic>> groupedScheduleLocations;

  void _sheetEditSubject(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => EditSubjectSheet(subjObj: widget.subject, classId: widget.mClassObj.id, classColor: widget.mClassObj.color, onSubjectCreated: (sbj) {
        widget.onEdited(sbj);
      },),
    );
  }

  void  _deleteSubject(BuildContext context) async {
    final subjectViewModel = context.read<ClassSubjectsViewModel>();

    final result = await subjectViewModel.deleteSubject(widget.mClassObj.id, widget.subject.id);

    if (result) {
      widget.onDeleted();
    } else if (subjectViewModel.error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(
          subjectViewModel.error!,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    color = generateMaterialColor(Color(widget.subject.color ?? 0));
    groupedSchedule = groupScheduleByTime(widget.subject.schedule);
    groupedScheduleLocations = groupScheduleByLocation(widget.subject.schedule);
  }

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(width: 2, color: color.shade800);

    final popupMenuItemsLeader = [
      const PopupMenuItem<String>(
        value: 'edit',
        child: Text('Editar'),
      ),
      const PopupMenuItem<String>(
        value: 'delete',
        child: Text('Apagar'),
      )
    ];

    /*final popupMenuItemsMember = [
      const PopupMenuItem<String>(
        value: 'leave',
        child: Text('Sair da turma'),
      )
    ];*/

    return ExpandablePanel(
      collapsed: ExpandableButton(
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.maxFinite,
          height: collapsedHeight,
          decoration: BoxDecoration(
            color: color.shade100,
            border: Border.fromBorderSide(border),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: sPadding3),
                  child: Row(
                    spacing: 16.0,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedBookBookmark02,
                        color: color.shade800,
                      ),
                      Expanded(
                        child: AutoSizeText(
                          widget.subject.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: color.shade800,
                              fontSize: 20
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              widget.mClassObj.role >= Role.viceLider
                  ? PopupMenuButton<String>(
                      shadowColor: Colors.grey,
                      menuPadding: EdgeInsets.zero,
                      icon: Icon(Icons.more_vert,
                          size: 24.0, color: color.shade800),
                      onSelected: (String value) async {
                        if (value == 'edit') {
                          _sheetEditSubject(context);
                        } else if (value == 'delete') {
                          _deleteSubject(context);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          popupMenuItemsLeader,
                      // atention: Offset de onde irá aparecer o menu (x, y)
                      offset: const Offset(-24, 24),
                    )
                  : Container()
            ],
          ),
        ),
      ),
      expanded: Container(
        decoration: BoxDecoration(
          color: color.shade50,
          border: Border.fromBorderSide(border),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Column(
          children: [
            ExpandableButton(
              child: Container(
                alignment: Alignment.centerLeft,
                height: collapsedHeight - 4,
                decoration: BoxDecoration(
                  color: color.shade100,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          0.2), // Cor da sombra (ajuste a opacidade)
                      spreadRadius:
                          0, // Quão longe a sombra se espalha antes do blur
                      blurRadius: 4, // A intensidade do desfoque da sombra
                      offset: Offset(0, 2), // Deslocamento da sombra:
                      // 0 no eixo X (horizontal)
                      // 2 (ou outro valor positivo) no eixo Y para mover a sombra para BAIXO
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: sPadding3),
                        child: Row(
                          spacing: 16.0,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedBookBookmark02,
                              color: color.shade800,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                widget.subject.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: color.shade800,
                                    fontSize: 20
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.mClassObj.role >= Role.viceLider
                        ? PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert,
                                size: 24.0, color: color.shade800),
                            onSelected: (String value) async {
                              if (value == 'edit') {
                                _sheetEditSubject(context);
                              } else if (value == 'delete') {
                                _deleteSubject(context);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                popupMenuItemsLeader,
                            // atention: Offset de onde irá aparecer o menu (x, y)
                            offset: const Offset(-24, 24),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(sPadding3),
              child: Column(
                spacing: 5.0,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      const HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar03,
                          color: Colors.black),
                      Expanded(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4,
                          children: groupedSchedule.map((e) {
                            return Row(
                              spacing: 8.0,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  spacing: 4,
                                  mainAxisSize: MainAxisSize.min,
                                  children: (e["days"] as List<String>)
                                      .map(
                                        (day) => Container(
                                          alignment: Alignment.center,
                                          width: 45,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 3.0),
                                          decoration: BoxDecoration(
                                            color: color.shade200,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(100),
                                            ),
                                          ),
                                          child: Text(
                                            dayOfWeekAbbreviated(day),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                                color: color.shade800),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                Text(
                                  "${e["time"]["start_time"]} ~ ${e["time"]["end_time"]}",
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.0,
                    children: [
                      const HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation04,
                          color: Colors.black),
                      groupedScheduleLocations.length < 2
                          ? Expanded(
                            child: Text(
                                groupedScheduleLocations[0]["location"],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.clip,
                              ),
                          )
                          : Expanded(
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4,
                                children: groupedScheduleLocations.map((e) {
                                  return Row(
                                    spacing: 8.0,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        spacing: 4,
                                        mainAxisSize: MainAxisSize.min,
                                        children: (e["days"] as List<String>)
                                            .map(
                                              (day) => Container(
                                                alignment: Alignment.center,
                                                width: 45,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3.0),
                                                decoration: BoxDecoration(
                                                  color: color.shade200,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                                child: Text(
                                                  dayOfWeekAbbreviated(day),
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: color.shade800),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      Text(
                                        "${e["location"]}",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        spacing: 8.0,
                        children: [
                          const HugeIcon(
                              icon: HugeIcons.strokeRoundedTeaching,
                              color: Colors.black),
                          Text(
                            widget.subject.teacher ?? "Sem professor",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      (widget.subject.pud != null &&
                              widget.subject.pud!.isNotEmpty)
                          ? SizedBox(
                              height: 30,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  side: BorderSide(color: color.shade900),
                                  foregroundColor: color.shade900,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  shadowColor: Colors.transparent,
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Onest",
                                      fontSize: 14),
                                ),
                                child: Row(
                                  spacing: 4,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    HugeIcon(
                                        size: 20,
                                        icon: HugeIcons.strokeRoundedLink04,
                                        color: color.shade900),
                                    const Text("PUD")
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  /*const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        foregroundColor: cColorTextWhite,
                        backgroundColor: color.shade900,
                        // side: const BorderSide(color: cColorPrimary),
                        elevation: 0,
                        padding: EdgeInsets.all(0),
                        shadowColor: Colors.transparent,
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Onest",
                            fontSize: 16),
                      ),
                      child: const Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                              size: 20,
                              icon: HugeIcons.strokeRoundedBooks02,
                              color: cColorTextWhite),
                          Text("Visualizar materiais")
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
