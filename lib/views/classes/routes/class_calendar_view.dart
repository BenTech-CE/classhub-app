import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/widgets/ui/weekly_date_picker.dart';
import 'package:flutter/material.dart';

class ClassCalendarView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassCalendarView({super.key, required this.mClassObj});

  @override
  State<ClassCalendarView> createState() => _ClassCalendarViewState();
}

class _ClassCalendarViewState extends State<ClassCalendarView> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WeeklyDatePicker(
          selectedDay: _selectedDay,
          changeDay: (value) => setState(() {
            _selectedDay = value;
          }),
          enableWeeknumberText: false,
          backgroundColor: Colors.transparent,
          selectedDigitBackgroundColor: cColorTextAzul,
          selectedDigitColor: cColorTextWhite,
          weekdayTextColor: Colors.black54,
          digitsColor: Colors.black54,
          weekdays: const ["Seg", "Ter", "Qua", "Qui", "Sex", "Sáb", "Dom"],
          daysInWeek: 7,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Segunda-feira, 16 de junho")
            ],
          ),
        )
        
      ],
    );
  }
}