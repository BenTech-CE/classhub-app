import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class WeekdayCard extends StatefulWidget {
  final SubjectModel subject;
  final String weekday;
  final VoidCallback onSubjectChanged; 

  const WeekdayCard({
    Key? key,
    required this.subject,
    required this.onSubjectChanged,
    required this.weekday
  }) : super(key: key);

  @override
  State<WeekdayCard> createState() => _WeekdayCardState();
}

class _WeekdayCardState extends State<WeekdayCard> {
  final timeInputWidth = 140.0;
  final _localTF = TextEditingController();

  void _showStartTimePicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: widget.subject.schedule[widget.weekday]!.startTime.isEmpty ? TimeOfDay.now() : (stringToTimeOfDay(widget.subject.schedule[widget.weekday]!.startTime) ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    setState(() {
      if (selectedTime != null) {
        widget.subject.schedule[widget.weekday]!.startTime = timeOfDayToString(selectedTime);
      }      
    });
    
    widget.onSubjectChanged();
  }

  void _showEndTimePicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: widget.subject.schedule[widget.weekday]!.endTime.isEmpty ? TimeOfDay.now() : (stringToTimeOfDay(widget.subject.schedule[widget.weekday]!.endTime) ?? TimeOfDay.now()),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    setState(() {
      if (selectedTime != null) {
        widget.subject.schedule[widget.weekday]!.endTime = timeOfDayToString(selectedTime);
      }      
    });
    
    widget.onSubjectChanged();
  }

  @override
  void initState() {
    super.initState();
    _localTF.text = widget.subject.schedule[widget.weekday]!.location;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        color: const Color(0xFFEBF3FF),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: ShapeDecoration(
              color: const Color(0xFF9BC6E5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Text(
                  dayOfWeekNormalized(widget.weekday),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: cColorPrimary,
                    fontSize: 12,
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Horário de Encontro",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: cColorTextAzul),
                  textAlign: TextAlign.start),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: timeInputWidth,
                    child: TextField(
                      onTap: () => _showStartTimePicker(),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const RoundedColoredInputBorder(),
                        enabledBorder: const RoundedColoredInputBorder(),
                        suffixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedAlarmClock, color: cColorPrimary),
                        hintText: widget.subject.schedule[widget.weekday]!.startTime.isEmpty ? "Início": widget.subject.schedule[widget.weekday]!.startTime,
                        hintStyle: const TextStyle(
                            fontFamily: "Onest",
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: cColorTextBlack
                        ),
                      ),
                    ),
                  ),
                  Text("às", style: Theme.of(context).textTheme.labelLarge),
                  SizedBox(
                    width: timeInputWidth,
                    child: TextField(
                      onTap: () => _showEndTimePicker(),
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const RoundedColoredInputBorder(),
                        enabledBorder: const RoundedColoredInputBorder(),
                        suffixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedAlarmClock, color: cColorPrimary),
                        hintText: widget.subject.schedule[widget.weekday]!.endTime.isEmpty ? "Fim": widget.subject.schedule[widget.weekday]!.endTime,
                        hintStyle: const TextStyle(
                            fontFamily: "Onest",
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: cColorTextBlack
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Local de Encontro",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: cColorTextAzul),
                  textAlign: TextAlign.start),
              TextField(
                controller: _localTF,
                onChanged: (value) {
                  setState(() {
                    widget.subject.schedule[widget.weekday]!.location = value;
                  });

                  widget.onSubjectChanged();
                },
                decoration: const InputDecoration(
                    border: RoundedColoredInputBorder(),
                    enabledBorder: RoundedColoredInputBorder(),
                    hintText: "Ex.: Sala 17",
                    hintStyle: TextStyle(
                        fontFamily: "Onest",
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: cColorText2Azul)),
              ),
            ]),
        ],
      ),
    );
  }
}