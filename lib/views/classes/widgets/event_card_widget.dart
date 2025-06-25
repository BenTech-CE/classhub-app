import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class EventCardWidget extends StatefulWidget {
  final EventModel event;

  const EventCardWidget({super.key, required this.event});

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
            children: [
              Text(
                widget.event.title, 
                overflow: TextOverflow.clip,
                style: const TextStyle(
                  color: cColorText1
                ),
              ),
              Row(
                spacing: 4,
                children: [
                  const HugeIcon(icon: HugeIcons.strokeRoundedClock01, color: cColorGray2, size: 16),
                  Text(
                    widget.event.isAllDay ? "Dia Todo, ${widget.event.location}" : "${convertUtcTimeToLocalFormatted(widget.event.startTime)}-${convertUtcTimeToLocalFormatted(widget.event.endTime)}, ${widget.event.location}",
                    style: const TextStyle(
                      color: cColorGray2
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}