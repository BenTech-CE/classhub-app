import 'dart:io';

import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/utils/mural_type.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/mural/create_post_mural_model.dart';
import 'package:classhub/models/class/notifications/notification_type.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/mural/class_mural_viewmodel.dart';
import 'package:classhub/viewmodels/class/notifications/class_notifications_viewmodel.dart';
import 'package:classhub/viewmodels/class/subjects/class_subjects_viewmodel.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPostWidget extends StatefulWidget {
  final MaterialColor classColor;
  final String classId;
  final VoidCallback onCreated;

  const NewPostWidget(
      {super.key,
      required this.classColor,
      required this.classId,
      required this.onCreated});

  @override
  State<NewPostWidget> createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> {
  final TextEditingController _tf = TextEditingController();

  final List<MuralType> tiposPost = [MuralType.AVISO, MuralType.MATERIAL];

  MuralType dropTipos = MuralType.AVISO;

  late String uname;

  late List<SubjectModel> materias;

  late SubjectModel idMateria;

  bool createLoading = false;

  List<XFile> _selectedAttachments = [];

  void _attach() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: Platform.isIOS ? FileType.media : FileType.custom,
      allowedExtensions: Platform.isIOS
          ? null
          : [
              'pdf',
              'doc',
              'docx',
              'odt',
              'txt',
              'epub',
              'ppt',
              'pptx',
              'odp',
              'xls',
              'xlsx',
              'ods',
              'csv',
              'jpg',
              'jpeg',
              'png',
              'gif',
              'svg',
              'webp',
              'mp4',
              'mov',
              'avi',
              'mp3',
              'wav',
              'm4a',
              'ogg',
              'opus'
            ],
    );

    if (result != null) {
      List<XFile> files = result.xFiles;

      setState(() {
        _selectedAttachments = files;
      });
    } else {
      print("Canceled file picker.");
    }
  }

  void _createPost() async {
    final cmvm = context.read<ClassMuralViewModel>();

    if (_tf.text.isNotEmpty && !cmvm.isLoading) {
      setState(() {
        createLoading = true;
      });

      final postModel = CreatePostMuralModel(
          type: dropTipos,
          description: _tf.text,
          subjectId:
              idMateria.id != "not-selected-subject" ? idMateria.id : null,
          attachments: _selectedAttachments);

      final result = await cmvm.createPost(widget.classId, postModel);

      if (result != null) {
        widget.onCreated();

        setState(() {
          _tf.text = "";
          _selectedAttachments.clear();
          createLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Postagem criada com sucesso!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: cColorSuccess,
        ));
      } else if (cmvm.error != null) {
        setState(() {
          createLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            cmvm.error!,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: cColorError,
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final uvm = context.read<UserViewModel>();
    uname = uvm.user!.name;

    final svm = context.read<ClassSubjectsViewModel>();
    materias = svm.getCachedSubjectsDoNotNotify(widget.classId);

    materias = [
      SubjectModel(
          id: "not-selected-subject",
          title: "Não associar",
          schedule: {},
          color: widget.classColor.toARGB32()),
      ...materias
    ];

    if (materias.isNotEmpty) {
      idMateria = materias.first;
    } else {
      idMateria = SubjectModel(
          id: "not-selected-subject",
          title: "Matéria",
          schedule: {},
          color: widget.classColor.toARGB32());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.171),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          CircleAvatar(
            radius: 20, // Define o raio do círculo
            backgroundColor:
                widget.classColor.shade200, // Define a cor de fundo
            child: Text(getNameInitials(uname),
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: widget
                        .classColor.shade900)), // Conteúdo dentro do círculo
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: widget.classColor.shade100, width: 2)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        TextField(
                          controller: _tf,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintText: "O que você deseja postar?",
                              hintStyle:
                                  TextStyle(color: cColorText3, fontSize: 16)),
                        ),
                        ..._selectedAttachments.mapIndexed(
                          (index, file) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: widget.classColor.shade50,
                              border: Border.all(
                                  color: widget.classColor.shade200, width: 2),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 4,
                              children: [
                                HugeIcon(
                                  icon:
                                      HugeIcons.strokeRoundedDocumentAttachment,
                                  color: widget.classColor.shade900,
                                  size: 20,
                                ),
                                Flexible(
                                  child: Text(
                                    file.name,
                                    style: const TextStyle(
                                      color: cColorText1,
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: IconButton(
                                    onPressed: () {
                                      // Remover anexo

                                      setState(() {
                                        _selectedAttachments.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: widget.classColor.shade100,
                    thickness: 2,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 8,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                PopupMenuButton<MuralType>(
                                  padding: const EdgeInsets.all(0),
                                  menuPadding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  shadowColor: Colors.grey,
                                  offset: const Offset(0, 28),
                                  itemBuilder: (context) {
                                    return tiposPost.map((str) {
                                      return PopupMenuItem(
                                        value: str,
                                        height: 24,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: widget.classColor.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(999)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                str.type.toCapitalized(),
                                                style: TextStyle(
                                                    color: widget
                                                        .classColor.shade900,
                                                    fontSize: 14),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (MuralType value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropTipos = value;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.classColor.shade200,
                                        borderRadius:
                                            BorderRadius.circular(999)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          dropTipos.type.toCapitalized(),
                                          style: TextStyle(
                                              color: widget.classColor.shade900,
                                              fontSize: 14),
                                          textAlign: TextAlign.end,
                                        ),
                                        Icon(Icons.arrow_drop_down,
                                            color: widget.classColor.shade900,
                                            size: 16),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuButton<SubjectModel>(
                                  padding: const EdgeInsets.all(0),
                                  menuPadding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  shadowColor: Colors.grey,
                                  offset: const Offset(0, 28),
                                  itemBuilder: (context) {
                                    return materias.map((mt) {
                                      final matColor = generateMaterialColor(
                                          Color(mt.color!));

                                      return PopupMenuItem(
                                        value: mt,
                                        height: 24,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: matColor.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(999)),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                mt.title,
                                                style: TextStyle(
                                                    color: matColor.shade900,
                                                    fontSize: 14),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                  onSelected: (SubjectModel value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      idMateria = value;
                                    });
                                  },
                                  child: Builder(builder: (context) {
                                    final matColor = generateMaterialColor(
                                        Color(idMateria.color!));
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: matColor.shade200,
                                          borderRadius:
                                              BorderRadius.circular(999)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            idMateria.id ==
                                                    "not-selected-subject"
                                                ? "Matéria"
                                                : idMateria.title,
                                            style: TextStyle(
                                                color: matColor.shade900,
                                                fontSize: 14),
                                            textAlign: TextAlign.end,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Icon(Icons.arrow_drop_down,
                                              color: matColor.shade900,
                                              size: 16),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                                GestureDetector(
                                  onTap: _attach,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: widget.classColor.shade200,
                                        borderRadius:
                                            BorderRadius.circular(999)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 4,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedAttachment,
                                            color: widget.classColor.shade900,
                                            size: 16),
                                        Text(
                                          "Anexo",
                                          style: TextStyle(
                                              color: widget.classColor.shade900,
                                              fontSize: 14),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: _createPost,
                            child: createLoading
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(4),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ))
                                : SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: HugeIcon(
                                      icon: HugeIcons.strokeRoundedArrowRight02,
                                      color: widget.classColor.shade900,
                                    )))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
