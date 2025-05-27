import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/subjects/schedule_weekday_model.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:flutter/material.dart';

class WeekdaySelect extends StatefulWidget {
  final SubjectModel subject;
  final VoidCallback onSubjectChanged; 

  const WeekdaySelect({
    Key? key,
    required this.subject,
    required this.onSubjectChanged,
  }) : super(key: key);

  @override
  State<WeekdaySelect> createState() => _WeekdaySelectState();
}

class _WeekdaySelectState extends State<WeekdaySelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 376,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: const Color(0xFFEBF3FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 4,
        children: widget.subject.schedule.entries.map((entry) =>
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (entry.value == null) {
                    widget.subject.schedule[entry.key] = ScheduleWeekday(startTime: "", endTime: "", location: "");
                  } else {
                    widget.subject.schedule[entry.key] = null;
                  }
                });

                widget.onSubjectChanged();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: ShapeDecoration(
                  color: entry.value == null ? cColorTertiary2 : Color(0xFF9BC6E5),
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
                      dayOfWeekAbbreviated(entry.key),
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
            ),
          ),
        ).toList(),
      ),
    );
  }
}
