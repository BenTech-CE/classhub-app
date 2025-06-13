import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/models/class/management/class_widget.model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NewCardWidget extends StatefulWidget {
  final MaterialColor classColor;

  const NewCardWidget({
    Key? key,
    required this.classColor,
    
  }) : super( key: key );

  @override
  State<NewCardWidget> createState() => _NewCardWidgetState();
}

class _NewCardWidgetState extends State<NewCardWidget> {
  final color = const Color.fromARGB(255, 194, 194, 194);

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
        width: double.maxFinite,
        height: 130,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(24),
          splashColor: color.withOpacity(0.1),
          child: Ink(
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                radius: const Radius.circular(24),
                strokeWidth: 4,
                dashPattern: [15,15],
                padding: const EdgeInsets.all(sPadding3),
                color: color
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedPlusSignCircle, color: color, size: 40),
                    Text("Criar Novo Cartão", style: TextStyle(
                      fontFamily: "Onest",
                      color: color
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
