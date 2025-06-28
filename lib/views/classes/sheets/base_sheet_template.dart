
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:flutter/material.dart';

class BaseSheetTemplate extends StatefulWidget {
  const BaseSheetTemplate({super.key});

  @override
  State<BaseSheetTemplate> createState() => _BaseSheetTemplateState();
}

class _BaseSheetTemplateState extends State<BaseSheetTemplate> {
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
              spacing: sSpacing,
              children: [
                Text("Título da Sheet",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center
                ),

                // outros componentes ficam aqui nesa column
                
              ],
            )
          ),
        ),
      ),
    );
  }
}
