import 'package:classhub/core/extensions/date.dart';
import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/class/calendar/class_calendar_viewmodel.dart';
import 'package:classhub/views/classes/routes/calendar/create_event_sheet.dart';
import 'package:classhub/views/classes/widgets/event_card_widget.dart';
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
  DateTime _selectedDay = DateTime.now();
  
  final DateFormat _formatter = DateFormat("EEEE, d 'de' MMMM", 'pt-BR');

  String currentMode = "calendar";
  late String modeText = _formatter.format(_selectedDay).toCapitalized();
  //late String modeText = "Todos os eventos";

  void _sheetCreateEvent() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => CreateEventSheet(classId: widget.mClassObj.id, selectedDay: _selectedDay),
    );
  }

  Future<void> _fetchEvents() async {
    final cevm = context.read<ClassCalendarViewModel>();

    await cevm.getEvents(widget.mClassObj.id, null);

    if(cevm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Não foi possível acessar os eventos da turma.",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      print(cevm.error);
    }

    return;
  }

  List<EventModel> _getCalendarEventsForDay(DateTime day) {
    final cevm = context.read<ClassCalendarViewModel>();

    final evts = cevm.events
      .where((ev) => ev.date.toDate()?.dateOnly.isSameDateAs(day) ?? false)
      .toList();

    return evts;
  }

  @override void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchEvents();

      /*setState(() {
        currentMode = "upcoming365";
        modeText = "Todos os eventos";
      });*/
    });

  }



  @override
  Widget build(BuildContext context) {
    final cevm = context.watch<ClassCalendarViewModel>();

    final classColor = generateMaterialColor(Color(widget.mClassObj.color));

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Consumer<ClassCalendarViewModel>(
        builder: (context, vm, child) {
          List<EventModel> eventsForSelectedDay = [];

          if (currentMode == 'calendar') {
            eventsForSelectedDay = vm.events
              .where((ev) => ev.date.toDate()?.dateOnly.isSameDateAs(_selectedDay) ?? false)
              .toList();
          } else {
            eventsForSelectedDay = vm.upcomingEvents
              .toList();
          }

          return Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    currentMode = "calendar";
                    modeText = _formatter.format(selectedDay).toCapitalized();
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          shadowColor: Colors.grey,
                          menuPadding: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          onSelected: (String value) async {
                            setState(() {
                              currentMode = value;

                              switch (currentMode) {
                                case 'calendar':
                                  modeText = _formatter.format(_selectedDay).toCapitalized();
                                  break;
                                case 'upcoming7':
                                  modeText = "Próximos 7 dias";
                                  cevm.getEvents(widget.mClassObj.id, "7");
                                  break;
                                case 'upcoming30':
                                  modeText = "Próximos 30 dias";
                                  cevm.getEvents(widget.mClassObj.id, "30");
                                  break;
                                case 'upcoming365':
                                  modeText = "Todos os eventos";
                                  cevm.getEvents(widget.mClassObj.id, "365");
                                  break;
                                default:
                                  modeText = _formatter.format(_selectedDay).toCapitalized();
                              }
                            });
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'calendar',
                              child: Text(_formatter.format(_selectedDay).toCapitalized()),
                            ),
                            const PopupMenuItem<String>(
                              value: 'upcoming7',
                              child: Text("Próximos 7 dias"),
                            ),
                            const PopupMenuItem<String>(
                              value: 'upcoming30',
                              child: Text("Próximos 30 dias"),
                            ),
                            const PopupMenuItem<String>(
                              value: 'upcoming365',
                              child: Text("Todos os eventos"),
                            ),
                          ],
                          // atention: Offset de onde irá aparecer o menu (x, y)
                          offset: const Offset(0, 24),
                          child: Row(
                            children: [
                              Text(
                                modeText,
                                style: const TextStyle(
                                  color: cColorText1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 4,),
                              const Icon(Icons.arrow_drop_down_rounded,
                                size: 24.0, color: cColorText2
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (widget.mClassObj.role >= Role.viceLider)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [SizedBox(
                            width: 24,
                            height: 24,
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              constraints: const BoxConstraints(),
                              onPressed: _sheetCreateEvent, 
                              icon: Icon(Icons.add, color: classColor.shade900)
                            ),
                          ),],
                        )
                      ],
                    ),
                    if (cevm.isLoading)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      )
                    else if (eventsForSelectedDay.isEmpty)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("Nenhum evento programado.")],
                      )
                    else
                      ...eventsForSelectedDay.map((ev) => EventCardWidget(canEdit: widget.mClassObj.role >= Role.viceLider, classId: widget.mClassObj.id, event: ev, showDate: currentMode != 'calendar')).toList(),
                  ],
                ),
              )
              
            ],  
          );
        },
      ),
    );
  }
}