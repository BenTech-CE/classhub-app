import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/widgets/ui/weekly_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClassCalendarView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassCalendarView({super.key, required this.mClassObj});

  @override
  State<ClassCalendarView> createState() => _ClassCalendarViewState();
}

class _ClassCalendarViewState extends State<ClassCalendarView> {
  DateTime _selectedDay = DateTime.now();
  
  final DateFormat _formatter = DateFormat("EEEE, d 'de' MMMM", 'pt-BR');

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: sSpacing,
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
          padding: EdgeInsets.symmetric(horizontal: sPadding), 
          child: Column(
            spacing: sSpacing,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatter.format(_selectedDay).toCapitalized(),
                style: const TextStyle(
                  color: cColorText1,
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              )
            ],
          ),
        )
        
      ],
    );
  }
}