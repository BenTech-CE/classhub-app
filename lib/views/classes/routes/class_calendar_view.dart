import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:flutter/material.dart';

class ClassCalendarView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassCalendarView({super.key, required this.mClassObj});

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