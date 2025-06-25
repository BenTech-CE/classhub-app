import 'package:classhub/core/extensions/date.dart';
import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/class/calendar/class_calendar_viewmodel.dart';
import 'package:classhub/views/classes/widgets/event_card_widget.dart';
import 'package:classhub/widgets/ui/weekly_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClassCalendarView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassCalendarView({super.key, required this.mClassObj});

  @override
  State<ClassCalendarView> createState() => _ClassCalendarViewState();
}

class _ClassCalendarViewState extends State<ClassCalendarView> {
  DateTime _selectedDay = DateTime.now();
  
  final DateFormat _formatter = DateFormat("EEEE, d 'de' MMMM", 'pt-BR');

  List<EventModel> _events = [];

  void _fetchEvents() async {
    final cevm = context.read<ClassCalendarViewModel>();

    final res = await cevm.getEvents(widget.mClassObj.id, null);

    if(cevm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Erro ao procurar eventos",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      print(cevm.error);
    } else {
      setState(() {
        _events = res;
      });
    }
  }

  @override void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    final cevm = context.watch<ClassCalendarViewModel>();

    final eventsForSelectedDay = _events
    .where((ev) => ev.date.toDate()?.dateOnly.isSameDateAs(_selectedDay) ?? false)
    .toList();

    return Column(
      spacing: 8,
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
          padding: const EdgeInsets.symmetric(horizontal: sPadding), 
          child: Column(
            spacing: sSpacing,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _formatter.format(_selectedDay).toCapitalized(),
                style: const TextStyle(
                  color: cColorText1,
                  fontSize: 22,
                  fontWeight: FontWeight.w600
                ),
              ),
              if (cevm.isLoading)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                )
              else if (eventsForSelectedDay.isEmpty)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Nenhum evento neste dia.")],
                )
              else
                ...eventsForSelectedDay.map((ev) => EventCardWidget(event: ev)).toList(),
            ],
          ),
        )
        
      ],
    );
  }
}