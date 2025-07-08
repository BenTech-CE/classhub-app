import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/notifications/notification_type.dart';
import 'package:classhub/viewmodels/class/notifications/class_notifications_viewmodel.dart';
import 'package:classhub/views/classes/widgets/switch_notifications_widget.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsConfig extends StatefulWidget {
  final String classId;

  const NotificationsConfig({super.key, required this.classId});

  @override
  State<NotificationsConfig> createState() => NotificationsConfigState();
}

class NotificationsConfigState extends State<NotificationsConfig> {
  late bool noticesNotifications;
  late bool materialsNotifications;
  late bool nextEventsNotifications;

  late bool oldNoticesNotifications;
  late bool oldMaterialsNotifications;
  late bool oldNextEventsNotifications;

  bool isLoading = false;

  void _save() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final cnvm = context.read<ClassNotificationsViewModel>();
    
    if (noticesNotifications != oldNoticesNotifications) { 
      if (noticesNotifications) {
        await cnvm.subscribe(NotificationType.new_alert, widget.classId);
      } else {
        await cnvm.unsubscribe(NotificationType.new_alert, widget.classId);
      }
    }

    if (materialsNotifications != oldMaterialsNotifications) {
      if (materialsNotifications) {
        await cnvm.subscribe(NotificationType.new_material, widget.classId);
      } else {
        await cnvm.unsubscribe(NotificationType.new_material, widget.classId);
      }
    }

    if (nextEventsNotifications != oldNextEventsNotifications) {
      if (nextEventsNotifications) {
        await cnvm.subscribe(NotificationType.event_created, widget.classId);
      } else {
        await cnvm.unsubscribe(NotificationType.event_created, widget.classId);
      }
    }

    if (cnvm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Algumas configurações não puderam ser salvas.",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      setState(() {
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Configurações salvas com sucesso!",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();

    final cnvm = context.read<ClassNotificationsViewModel>();

    noticesNotifications = cnvm.isSubscribedTo(NotificationType.new_alert, widget.classId);
    materialsNotifications = cnvm.isSubscribedTo(NotificationType.new_material, widget.classId);
    nextEventsNotifications = cnvm.isSubscribedTo(NotificationType.event_created, widget.classId);

    oldNoticesNotifications = cnvm.isSubscribedTo(NotificationType.new_alert, widget.classId);
    oldMaterialsNotifications = cnvm.isSubscribedTo(NotificationType.new_material, widget.classId);
    oldNextEventsNotifications = cnvm.isSubscribedTo(NotificationType.event_created, widget.classId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // <-- adicionando scroll
        child: Padding(
          // <-- este padding é o padding de quando o teclado está na tela
          padding: EdgeInsets.only(
              // ^ ^ ^
              bottom: MediaQuery.of(context).viewInsets.bottom + sPadding3),
          child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: sPadding3), // <-- padding da sheet (padronizado)
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sSpacing,
                children: [
                  Text("Configuração de Notificações",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: cColorPrimary),
                      textAlign: TextAlign.center),

                  // outros componentes ficam aqui nesa column
                  Text("Receber notificações de:",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black87),
                      textAlign: TextAlign.start
                  ),

                  SwitchNotification(
                    name: "Avisos", 
                    value: noticesNotifications, 
                    onChanged: (newValue) {
                      setState(() {
                        noticesNotifications = newValue;
                      });
                    },
                  ),

                  SwitchNotification(
                    name: "Materiais", 
                    value: materialsNotifications, 
                    onChanged: (newValue) {
                      setState(() {
                        materialsNotifications = newValue;
                      });
                    },
                  ),

                  SwitchNotification(
                    name: "Eventos Próximos", 
                    value: nextEventsNotifications, 
                    onChanged: (newValue) {
                      setState(() {
                        nextEventsNotifications = newValue;
                      });
                    },
                  ),

                  ElevatedButton(
                    onPressed: _save,
                    child: isLoading ? const LoadingWidget() : Text("Salvar",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: cColorTextWhite)),
                  ),

                ],
              )),
        ),
      ),
    );
  }
}
