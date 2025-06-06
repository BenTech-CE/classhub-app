import 'dart:math';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class PopupWidget extends StatefulWidget {
  final Widget? icon;
  final String title;
  final String description;

  const PopupWidget(
      {Key? key, this.icon, required this.title, required this.description})
      : super(key: key);

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 1));

    WidgetsBinding.instance.addPostFrameCallback((_) => _confetti.play());
  }

  @override
  void dispose() {
    super.dispose();
    _confetti.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AlertDialog(
          insetPadding:
              EdgeInsets.symmetric(horizontal: sPadding2, vertical: sPadding2),
          iconPadding: EdgeInsets.only(top: sPadding2 + 8, bottom: sPadding3),
          icon: widget.icon,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Confetti.launch(context,
              // particleBuilder: () => Star(),
              //     options: const ConfettiOptions(
              //         particleCount: 100, spread: 70, y: 0.6)),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: cColorPrimary),
              ),
            ],
          ),
          content: Text(widget.description,
              style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.5 + 120,
          left: MediaQuery.of(context).size.width * 0.5 + 30,
          child: ConfettiWidget(
            confettiController: _confetti,
            emissionFrequency: 0.5,
            maxBlastForce: 20,
            minBlastForce: 1,
            blastDirection: (7*pi) /4,
            blastDirectionality: BlastDirectionality.directional,
          ),
        ),
      ],
    );
  }
}
