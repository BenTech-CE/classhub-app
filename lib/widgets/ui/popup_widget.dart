import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class PopupWidget extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String description;
  const PopupWidget(
      {Key? key, this.icon, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding:
          EdgeInsets.symmetric(horizontal: sPadding2, vertical: sPadding2),
      iconPadding: EdgeInsets.only(top: sPadding2 + 8, bottom: sPadding3),
      icon: icon,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Confetti.launch(context,
          // particleBuilder: () => Star(),
          //     options: const ConfettiOptions(
          //         particleCount: 100, spread: 70, y: 0.6)),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: cColorPrimary),
          ),
        ],
      ),
      content: Text(description, style: Theme.of(context).textTheme.bodyMedium),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
