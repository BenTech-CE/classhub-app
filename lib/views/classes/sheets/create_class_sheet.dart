import 'dart:typed_data';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/theme/textfields.dart';
import 'package:classhub/core/theme/texts.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/class_owner_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/management/class_management_viewmodel.dart';
import 'package:flutter/material.dart';
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

  // Ação de quando clicar no botão de escolher banner da turma
  void _btnBanner() async {
    XFile? newImg = await picker.pickImage(source: ImageSource.gallery);
    if (newImg != null) {
      final bytes = await newImg.readAsBytes();
      setState(() {
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
      owner: ClassOwnerModel(
        id: userViewModel.user?.id ?? "",
        name: userViewModel.user?.name ?? "",
      ),
      banner: selectedBanner,
    );

    final ClassModel? classCreated =
        await classManagementViewModel.createClass(classModel);

    if (classCreated != null) {
      await userViewModel.fetchUser();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Turma criada com sucesso!",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorSuccess,
      ));
    } else if (classManagementViewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          classManagementViewModel.error!,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));
    }

    Navigator.popUntil(context, (route) => route.isFirst);
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
    return DraggableScrollableSheet(
      minChildSize: 0.56,
      initialChildSize: 0.56,
      maxChildSize: 0.9,
      expand: false,
      snap: true,
      snapSizes: const [0.56, 0.9],
      shouldCloseOnMinExtent: false,
      builder: (_, controller) => AnimatedPadding(
          padding: EdgeInsets.fromLTRB(sPadding3, 0, sPadding3,
              MediaQuery.of(context).viewInsets.bottom),
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: ListView(
            controller: controller,
            children: <Widget>[
              Text("Criar Turma",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: cColorPrimary),
                  textAlign: TextAlign.center),
              const SizedBox(height: sSpacing),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
              const SizedBox(height: sSpacing),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
              const SizedBox(height: sSpacing),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text("Banner da Turma",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: cColorTextAzul),
                    textAlign: TextAlign.start),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0)),
                                  image: DecorationImage(
                                    image: MemoryImage(selectedBanner!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : const HugeIcon(
                                icon: HugeIcons.strokeRoundedAlbum02,
                                color: cColorPrimary),
                      ),
                    ),
                  )
                ])
              ]),
              const SizedBox(height: sSpacing),
              ElevatedButton(
                child: const Text("Criar Turma"),
                onPressed: () => _btnCreate(context),
              ),
            ],
          )),
    );
  }
}
