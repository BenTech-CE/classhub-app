import 'package:classhub/core/extensions/date.dart';
import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/class/calendar/class_calendar_viewmodel.dart';
import 'package:classhub/views/classes/widgets/event_card_widget.dart';
import 'package:classhub/widgets/ui/weekly_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassCalendarView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassCalendarView({super.key, required this.mClassObj});

  @override
  State<ClassCalendarView> createState() => _ClassCalendarViewState();
}

class _ClassCalendarViewState extends State<ClassCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  
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

  List<EventModel> _getCalendarEventsForDay(DateTime day) {
    final evts = _events
      .where((ev) => ev.date.toDate()?.dateOnly.isSameDateAs(day) ?? false)
      .toList();

    return evts;
  }

  @override void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchEvents());
  }



  @override
  Widget build(BuildContext context) {
    final cevm = context.watch<ClassCalendarViewModel>();

    final classColor = generateMaterialColor(Color(widget.mClassObj.color));

    final eventsForSelectedDay = _events
    .where((ev) => ev.date.toDate()?.dateOnly.isSameDateAs(_focusedDay) ?? false)
    .toList();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*WeeklyDatePicker(
            selectedDay: _focusedDay,
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
          ),*/
          TableCalendar(
            availableCalendarFormats: const {
              CalendarFormat.month: 'Mês',
            },
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              return _getCalendarEventsForDay(day);
            },
            locale: 'pt-br',
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarStyle: CalendarStyle(
              // Estilo para os marcadores de evento
              markerDecoration: BoxDecoration(
                // Cor de preenchimento do círculo
                color: classColor.shade100,
                // Formato do marcador
                shape: BoxShape.circle,
                // Adiciona uma borda ao redor do círculo
                border: Border.all(
                  color: classColor.shade900, // Cor da borda (um cinza escuro)
                  width: 1.0,            // Largura da borda
                ),
              ),
              selectedDecoration: BoxDecoration(
                color: classColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: classColor.shade200,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(
                color: cColorText1,
                fontSize: 18.0,
              ),
              leftChevronIcon: Icon(Icons.chevron_left_rounded, color: cColorText2),
              rightChevronIcon: Icon(Icons.chevron_right_rounded, color: cColorText2)
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: sPadding), 
            child: Column(
              spacing: sSpacing,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _formatter.format(_focusedDay).toCapitalized(),
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
      ),
    );
  }
}