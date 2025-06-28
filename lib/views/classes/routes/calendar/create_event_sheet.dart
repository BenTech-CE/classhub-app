import 'dart:typed_data';

import 'package:classhub/core/extensions/date.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/calendar/class_calendar_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/classes/class_view.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEventSheet extends StatefulWidget {

  final DateTime selectedDay;
  final String classId;

  const CreateEventSheet({super.key, required this.classId, required this.selectedDay});

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  final _titleTF = TextEditingController();
  final _descTF = TextEditingController();

  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();

  final timeInputWidth = 140.0;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final _startPickerFocus = FocusNode();
  final _endPickerFocus = FocusNode();

  final _localTF = TextEditingController();
  final _localFocus = FocusNode();

  void _showStartTimePicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    setState(() {
      if (selectedTime != null) {
        _startTime = selectedTime;
      }      
    });
  }

  void _showEndTimePicker() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    setState(() {
      if (selectedTime != null) {
        _endTime = selectedTime;
      }      
    });
  }

  bool isAllDay = false;

  void _btnCreate() async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay);

    EventModel ev = EventModel(
      title: _titleTF.text,
      date: formattedDate,
      isAllDay: isAllDay,
      location: _localTF.text.isNotEmpty ? _localTF.text : null,
      description: _descTF.text.isNotEmpty ? _descTF.text : null,
    );

    if (!isAllDay && _startTime != null && _endTime != null) {
      ev.startTime = timeOfDayToUtc(_startTime!).formattedHHmmSS();
      ev.endTime = timeOfDayToUtc(_endTime!).formattedHHmmSS();
    }

    final cevm = context.read<ClassCalendarViewModel>();
    EventModel? result = await cevm.createEvent(widget.classId, ev);

    if (result != null) {
      cevm.getEvents(widget.classId, null);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Evento criado com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));

      Navigator.of(context).pop();
    } else if (cevm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          cevm.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      //Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleTF.dispose();
    _titleFocus.dispose();
    _descTF.dispose();
    _descFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColor = generateMaterialColor(cColorPrimary);
    final cevm = context.watch<ClassCalendarViewModel>();

    return SafeArea(
      child: SingleChildScrollView( // <-- adicionando scroll
        child: Padding( // <-- este padding é o padding de quando o teclado está na tela
          padding: EdgeInsets.only( // ^ ^ ^
              bottom: MediaQuery.of(context).viewInsets.bottom + sPadding3),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: sPadding3), // <-- padding da sheet (padronizado)
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: sSpacing,
              children: [
                Text("Criar Evento em ${widget.selectedDay.formattedDDmmYYYY()}",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Título",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cColorTextAzul),
                        textAlign: TextAlign.start),
                    TextField(
                      controller: _titleTF,
                      focusNode: _titleFocus,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocus);
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: RoundedColoredInputBorder(),
                        enabledBorder: RoundedColoredInputBorder(),
                        hintText: "Ex.: Prova de Matemática",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: cColorText2Azul),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Descrição",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cColorTextAzul),
                        textAlign: TextAlign.start),
                    TextField(
                      controller: _descTF,
                      focusNode: _descFocus,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: RoundedColoredInputBorder(),
                        enabledBorder: RoundedColoredInputBorder(),
                        hintText: "Ex.: Prova de Álgebra.\nConteúdo: Livro 'Matemática Pra Valer’, páginas 117-132.",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: cColorText2Azul,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dia Todo?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: cColorTextAzul),
                      textAlign: TextAlign.start
                    ),
                    Switch(
                      value: isAllDay, 
                      activeTrackColor: cColorPrimary,
                      inactiveTrackColor: appColor.shade100,
                      activeColor: Colors.white,
                      //trackOutlineColor: WidgetStatePropertyAll(outlineColor),
                      onChanged: (bool value) {
                        setState(() {
                          isAllDay = value;
                        });
                      },
                    ),
                    
                  ],
                ),
                if (!isAllDay)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Horário de Encontro",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cColorTextAzul),
                        textAlign: TextAlign.start),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: timeInputWidth,
                          child: TextField(
                            onTap: () => _showStartTimePicker(),
                            readOnly: true,
                            focusNode: _startPickerFocus,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_endPickerFocus);
                            },
                            decoration: InputDecoration(
                              border: const RoundedColoredInputBorder(),
                              enabledBorder: const RoundedColoredInputBorder(),
                              suffixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedAlarmClock, color: cColorPrimary),
                              hintText: _startTime != null ? timeOfDayToString(_startTime!) : "Início",
                              hintStyle: const TextStyle(
                                  fontFamily: "Onest",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: cColorTextBlack
                              ),
                            ),
                          ),
                        ),
                        Text("às", style: Theme.of(context).textTheme.labelLarge),
                        SizedBox(
                          width: timeInputWidth,
                          child: TextField(
                            onTap: () => _showEndTimePicker(),
                            readOnly: true,
                            focusNode: _endPickerFocus,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_localFocus);
                            },
                            decoration: InputDecoration(
                              border: const RoundedColoredInputBorder(),
                              enabledBorder: const RoundedColoredInputBorder(),
                              suffixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedAlarmClock, color: cColorPrimary),
                              hintText: _endTime != null ? timeOfDayToString(_endTime!) : "Fim",
                              hintStyle: const TextStyle(
                                  fontFamily: "Onest",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: cColorTextBlack
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Local de Encontro",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cColorTextAzul),
                        textAlign: TextAlign.start),
                    TextField(
                      controller: _localTF,
                      focusNode: _localFocus,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        border: RoundedColoredInputBorder(),
                        enabledBorder: RoundedColoredInputBorder(),
                        hintText: "Ex.: Auditório",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: cColorText2Azul),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _btnCreate,
                  child: cevm.isLoading
                      ? const LoadingWidget()
                      : const Text("Criar Evento"),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
