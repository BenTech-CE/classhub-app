import 'package:flutter/material.dart';

class ClassCalendarView extends StatefulWidget {
  const ClassCalendarView({super.key});

  @override
  State<ClassCalendarView> createState() => _ClassCalendarViewState();
}

class _ClassCalendarViewState extends State<ClassCalendarView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Calendar view")
      ],
    );
  }
}