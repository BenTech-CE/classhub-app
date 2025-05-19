import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:flutter/material.dart';

class JoinClassSheet extends StatefulWidget {
  const JoinClassSheet({super.key});

  @override
  State<JoinClassSheet> createState() => _JoinClassSheetState();
}

class _JoinClassSheetState extends State<JoinClassSheet> {
  final _inviteCodeTF = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _inviteCodeTF.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.25,
      initialChildSize: 0.25,
      maxChildSize: 0.25,
      expand: false,
      builder: (_, controller) => Container(
          padding: const EdgeInsets.symmetric(horizontal: sPadding3),
          child: ListView(
            controller: controller,
            children: <Widget>[
              Text("Entrar em turma existente",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center),
              const SizedBox(height: sSpacing),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text("Código da Turma",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: cColorTextAzul),
                    textAlign: TextAlign.start),
                TextField(
                  controller: _inviteCodeTF,
                  decoration: const InputDecoration(
                      border: RoundedColoredInputBorder(),
                      enabledBorder: RoundedColoredInputBorder(),
                      hintText: "Ex.: 123456",
                      hintStyle: TextStyle(
                          fontFamily: "Onest",
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: cColorText2Azul)),
                ),
              ]),
              const SizedBox(height: sSpacing),
              ElevatedButton(
                child: const Text('Entrar na Turma'),
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ],
          )),
    );
  }
}
