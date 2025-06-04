import 'dart:typed_data';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/class_owner_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:classhub/views/classes/class_view.dart';
import 'package:classhub/widgets/ui/loading_widget.dart';
import 'package:classhub/widgets/ui/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateClassSheet extends StatefulWidget {
  const CreateClassSheet({super.key});

  @override
  State<CreateClassSheet> createState() => _CreateClassSheetState();
}

class _CreateClassSheetState extends State<CreateClassSheet> {
  final _titleTF = TextEditingController();
  final _schoolTF = TextEditingController();

  final _titleFocus = FocusNode();
  final _schoolFocus = FocusNode();

  final ImagePicker picker = ImagePicker();

  // Essa variável guarda a imagem que a pessoa escolheu para ser o banner. É null se o banner não for escolhido.
  Uint8List? selectedBanner;
  XFile? selectedBannerFile;
  Color currentColor = Color(4280521466);

  // Ação de quando clicar no botão de escolher banner da turma
  void _btnBanner() async {
    XFile? newImg = await picker.pickImage(source: ImageSource.gallery);
    if (newImg != null) {
      final bytes = await newImg.readAsBytes();
      setState(() {
        selectedBannerFile = newImg;
        selectedBanner = bytes;
      });
    }
  }

  // Ação de quando clicar no botão de criar turma
  void _btnCreate(BuildContext ctx) async {
    final userViewModel = ctx.read<UserViewModel>();
    final classManagementViewModel = ctx.read<ClassManagementViewModel>();

    final classModel = ClassModel(
      name: _titleTF.text,
      school: _schoolTF.text,
      color: currentColor.toARGB32(),
      banner: selectedBannerFile,
    );

    final MinimalClassModel? classCreated =
        await classManagementViewModel.createClass(classModel);

    if (classCreated != null) {
      await userViewModel.fetchUser();
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text(
      //     "Turma criada com sucesso!",
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: cColorSuccess,
      // ));
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => PopupWidget(
            title: 'Parabéns, você entrou na turma!',
            description:
                'Agora você pode visualizar materiais, avisos, eventos e informações sobre as matérias de sua turma!',
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedParty,
              color: cColorPrimary,
              size: 50,
            )),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ClassView(mClassObj: classCreated)));
    } else if (classManagementViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          classManagementViewModel.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));

      Navigator.popUntil(context, (route) => route.isFirst);
    }
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
  void dispose() {
    super.dispose();
    _titleTF.dispose();
    _schoolTF.dispose();
    _titleFocus.dispose();
    _schoolFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassManagementViewModel classManagementViewModel =
        context.watch<ClassManagementViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + sPadding3),
          child: Container(
              // height: 510,
              // constraints: new BoxConstraints(minHeight: 510, maxHeight: 600),
              padding: const EdgeInsets.symmetric(horizontal: sPadding3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sSpacing,
                children: [
                  Text("Criar Turma",
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
                          controller: _titleTF,
                          focusNode: _titleFocus,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_schoolFocus);
                          },
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                              border: RoundedColoredInputBorder(),
                              enabledBorder: RoundedColoredInputBorder(),
                              hintText: "Ex.: USP - Medicina",
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
                        Text("Local de Encontro",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: cColorTextAzul),
                            textAlign: TextAlign.start),
                        TextField(
                          controller: _schoolTF,
                          focusNode: _schoolFocus,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: const RoundedColoredInputBorder(),
                              enabledBorder: const RoundedColoredInputBorder(),
                              hintText: "Ex.: USP - R. da Reitoria, 374",
                              hintStyle: AppTextTheme.placeholder),
                        ),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Banner da Turma",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: cColorTextAzul),
                            textAlign: TextAlign.start),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const HugeIcon(
                                  icon: HugeIcons.strokeRoundedIdea01,
                                  color: cColorPrimary),
                              const SizedBox(width: 5.0),
                              Expanded(
                                child: Text(
                                  "Dica: Clique no botão ao lado para selecionar a foto da turma!",
                                  style: AppTextTheme.placeholder,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              // Botão de Selecionar o Banner da Turma
                              SizedBox(
                                height: 90.0,
                                child: AspectRatio(
                                  aspectRatio: 2 / 1,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _btnBanner();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: cColorAzulSecondary,
                                        side: const BorderSide(
                                            color: cColorPrimary, width: 1.0),
                                        padding: const EdgeInsets.all(0.0)),
                                    child: selectedBanner != null
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12.0)),
                                              image: DecorationImage(
                                                image: MemoryImage(
                                                    selectedBanner!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : const HugeIcon(
                                            icon:
                                                HugeIcons.strokeRoundedAlbum02,
                                            color: cColorPrimary),
                                  ),
                                ),
                              )
                            ])
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
                    child: classManagementViewModel.isLoading
                        ? const LoadingWidget()
                        : const Text("Criar Turma"),
                    onPressed: () => _btnCreate(context),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
