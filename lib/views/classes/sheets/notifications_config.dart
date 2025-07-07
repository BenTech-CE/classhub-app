import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/views/classes/widgets/switch_notifications_widget.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';

class NotificationsConfig extends StatefulWidget {
  const NotificationsConfig({super.key});

  @override
  State<NotificationsConfig> createState() => NotificationsConfigState();
}

class NotificationsConfigState extends State<NotificationsConfig> {
  bool noticesNotifications = true;
  bool materialsNotifications = false;
  bool nextEventsNotifications = true;

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
                    onPressed: (){
                      //Salvar as informações

                      Navigator.of(context).pop();
                    },
                    child: Text("Salvar",
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
