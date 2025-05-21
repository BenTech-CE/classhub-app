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

  void _btnEntrar() {
    if (_inviteCodeTF.text.isNotEmpty) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _inviteCodeTF.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 210,
              padding: const EdgeInsets.symmetric(horizontal: sPadding3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sSpacing,
                children: [
                  Text("Entrar em turma existente",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: cColorPrimary),
                      textAlign: TextAlign.center),
                  Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text("Código da Turma",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cColorTextAzul),
                        textAlign: TextAlign.start),
                    TextField(
                      controller: _inviteCodeTF,
                      keyboardType: const TextInputType.numberWithOptions(),
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
                  ElevatedButton(
                    child: const Text('Entrar na Turma'),
                    onPressed: () => _btnEntrar(),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
