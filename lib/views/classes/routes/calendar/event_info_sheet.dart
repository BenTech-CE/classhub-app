
import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/viewmodels/class/calendar/class_calendar_viewmodel.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventInfoSheet extends StatefulWidget {
  final EventModel event;
  final String classId;
  final bool canEdit;

  const EventInfoSheet({super.key, required this.canEdit, required this.classId, required this.event});

  @override
  State<EventInfoSheet> createState() => _EventInfoSheetState();
}

class _EventInfoSheetState extends State<EventInfoSheet> {
  final DateFormat _formatter = DateFormat("EEEE, d 'de' MMMM", 'pt-BR');

  bool loading=false;

  void _del() async {
    if (loading) return;

    setState(() {
      loading = true;
    });

    final cevm = context.read<ClassCalendarViewModel>();

    final result = await cevm.deleteEvent(widget.classId, widget.event.id!);

    if (result) {
      cevm.getEvents(widget.classId, null);
      cevm.getEvents(widget.classId, "365");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Evento apagado com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));

      Navigator.of(context).pop();
    } else if (cevm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Não foi possível apagar este evento.",
          style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      //Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pop(context);

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              spacing: 16,
              children: [
                Text(widget.event.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center
                ),

                // outros componentes ficam aqui nesa column
                Text(
                  widget.event.description ?? "Sem descrição fornecida",
                  style: TextStyle(
                    color: cColorText1,
                    fontSize: 16,
                    fontStyle: widget.event.description != null ? FontStyle.normal : FontStyle.italic
                  )
                ),

                const Text(
                  "Data",
                  style: TextStyle(
                    color: cColorText1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ),

                Text(
                  _formatter.format(widget.event.date.toDate()!).toCapitalized(),
                  style: const TextStyle(
                    color: cColorText1,
                    fontSize: 16,
                  )
                ),

                const Text(
                  "Local",
                  style: TextStyle(
                    color: cColorText1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ),

                Text(
                  widget.event.location ?? "Local não informado",
                  style: TextStyle(
                    color: cColorText1,
                    fontSize: 16,
                    fontStyle: widget.event.location != null ? FontStyle.normal : FontStyle.italic
                  )
                ),

                const Text(
                  "Horário",
                  style: TextStyle(
                    color: cColorText1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )
                ),

                Text(
                  widget.event.isAllDay
                    ? "Dia Todo"
                    : "${convertUtcTimeToLocalFormatted(widget.event.startTime!)}-${convertUtcTimeToLocalFormatted(widget.event.endTime!)}",
                  style: const TextStyle(
                    color: cColorText1,
                    fontSize: 16,
                  )
                ),

                if (widget.canEdit)
                OutlinedButton(onPressed: _del, child: loading ? const LoadingWidget(color: cColorPrimary,) : const Text("Apagar Evento"))
              ],
            )
          ),
        ),
      ),
    );
  }
}
