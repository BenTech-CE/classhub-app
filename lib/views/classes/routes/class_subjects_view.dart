import 'package:flutter/material.dart';

class ClassSubjectsView extends StatefulWidget {
  const ClassSubjectsView({super.key});

  @override
  State<ClassSubjectsView> createState() => _ClassSubjectsViewState();
}

class _ClassSubjectsViewState extends State<ClassSubjectsView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Matérias view")
      ],
    );
  }
}