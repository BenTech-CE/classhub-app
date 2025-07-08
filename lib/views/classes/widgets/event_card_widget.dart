import 'package:classhub/core/extensions/date.dart';
import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/views/classes/routes/calendar/event_info_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EventCardWidget extends StatefulWidget {
  final EventModel event;
  final bool showDate;
  final String classId;
  final bool canEdit;

  const EventCardWidget({super.key, required this.canEdit, required this.classId, required this.event, required this.showDate});

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  void _sheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => EventInfoSheet(canEdit: widget.canEdit, classId: widget.classId, event: widget.event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _sheet,
      child: Row(
        spacing: 16,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: switch (widget.event.icon) {
                "book" => const HugeIcon(icon: HugeIcons.strokeRoundedBookOpen01, color: cColorText1),
                "presentation" => const HugeIcon(icon: HugeIcons.strokeRoundedPresentation07, color: cColorText1),
                _ => const HugeIcon(icon: HugeIcons.strokeRoundedBookOpen01, color: cColorText1)
              },
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.title, 
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: cColorText1,
                    fontSize: 16,
                    height: 1.2
                  ),
                  textAlign: TextAlign.start,
                ),
                if (widget.showDate)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 4,
                  children: [
                    const HugeIcon(icon: HugeIcons.strokeRoundedCalendar04, color: cColorGray2, size: 16),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: cColorGray2, fontFamily: "Onest", fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: widget.event.date.toDate()!.formattedDDmmYYYY()
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 4,
                  children: [
                    const HugeIcon(icon: HugeIcons.strokeRoundedClock01, color: cColorGray2, size: 16),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: cColorGray2, fontFamily: "Onest", fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(
                              text: widget.event.isAllDay
                                  ? "Dia Todo"
                                  : "${convertUtcTimeToLocalFormatted(widget.event.startTime!)}-${convertUtcTimeToLocalFormatted(widget.event.endTime!)}",
                            ),
                            const TextSpan(text: ", "),
                            TextSpan(
                              text: widget.event.location ?? "Local não definido",
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}