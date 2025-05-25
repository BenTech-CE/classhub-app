import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class CreateSubjectSheet extends StatefulWidget {
  const CreateSubjectSheet({super.key});

  @override
  State<CreateSubjectSheet> createState() => _CreateSubjectSheetState();
}

class _CreateSubjectSheetState extends State<CreateSubjectSheet> {
  Color currentColor = Color(4280521466);

  void _btnCreate(BuildContext context) {
    
  }

  void _colorPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          title: const Text('Selecione uma cor'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: currentColor,
              availableColors: listOfClassColors,
              onColorChanged: (color) {
                setState(() {
                  currentColor = color;
                });

                Navigator.of(ctx).pop();
              },
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ClassSubjectsViewModel subjectsViewModel =
        context.watch<ClassSubjectsViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + sPadding3),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: sPadding3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sSpacing,
                children: [
                  Text("Criar Matéria",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: cColorPrimary),
                      textAlign: TextAlign.center),
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
                          /*controller: _titleTF,
                          focusNode: _titleFocus,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_schoolFocus);
                          },*/
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              border: RoundedColoredInputBorder(),
                              enabledBorder: RoundedColoredInputBorder(),
                              hintText: "Ex.: Português I",
                              hintStyle: TextStyle(
                                  fontFamily: "Onest",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  color: cColorText2Azul)),
                        ),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Professor(a)",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: cColorTextAzul),
                            textAlign: TextAlign.start),
                        TextField(
                          //controller: _titleTF,
                          //focusNode: _titleFocus,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: const RoundedColoredInputBorder(),
                              enabledBorder: const RoundedColoredInputBorder(),
                              hintText: "Ex.: Maria da Silva",
                              hintStyle: AppTextTheme.placeholder),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Cor de destaque",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: cColorTextAzul),
                            textAlign: TextAlign.start),
                        GestureDetector(
                          onTap: () => _colorPicker(),
                          child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Image.asset("assets/images/rainbow.png",
                                    width: 45, height: 45),
                                Container(
                                  width: 37,
                                  height: 37,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentColor,
                                  ),
                                ),
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedPaintBoard,
                                  color: Colors.white,
                                  size: 29,
                                )
                              ]),
                        )
                      ]),
                  ElevatedButton(
                    child: subjectsViewModel.isLoading
                        ? const LoadingWidget()
                        : const Text("Criar Matéria"),
                    onPressed: () => _btnCreate(context),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}