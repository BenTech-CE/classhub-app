import 'package:classhub/core/extensions/string.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/mural/create_post_mural_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

class PostAlertWidget extends StatefulWidget {
  final MaterialColor classColor;
  final MuralModel post;

  const PostAlertWidget(
      {super.key, required this.classColor, required this.post});

  @override
  State<PostAlertWidget> createState() => _PostAlertWidgetState();
}

class _PostAlertWidgetState extends State<PostAlertWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: widget.classColor.shade100),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.classColor.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.171),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              spacing: 12,
              children: [
                CircleAvatar(
                  radius: 20, // Define o raio do círculo
                  backgroundColor:
                      widget.classColor.shade100, // Define a cor de fundo
                  child: Text(
                    (() {
                      final initials = widget.post.author.name
                          .trim()
                          .split(' ')
                          .map((sobrenome) => sobrenome[0].toCapitalized())
                          .join();
                      return initials.length > 2
                          ? initials.substring(0, 2)
                          : initials;
                    })(),
                    overflow: TextOverflow.clip,
                    style: TextStyle(color: widget.classColor),
                  ), // Conteúdo dentro do círculo
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 0,
                  children: [
                    Text(widget.post.author.name,
                        style: const TextStyle(color: Colors.black87)),
                    Text(widget.post.formattedCreatedAt,
                        style: const TextStyle(color: Colors.black87, fontSize: 12))
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                          if (widget.post.subject != null)
                            Builder(
                              builder: (context) {
                                final subjColor = generateMaterialColor(Color(widget.post.subject!.color));

                                return Container(
                                  decoration: BoxDecoration(
                                      color: subjColor.shade200,
                                      borderRadius: BorderRadius.circular(999)),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  child: Text(
                                    widget.post.subject!.title,
                                    style: TextStyle(
                                        color: subjColor.shade900, fontSize: 14),
                                    textAlign: TextAlign.end,
                                  ),
                                );
                              }
                            ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black87,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  widget.post.description.replaceAll('\\n', '\n'),
                  style: const TextStyle(color: Colors.black87),
                  textAlign: TextAlign.start,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 4,
                  runSpacing: 4,
                  children: widget.post.attachments.map((att) =>
                    Material(
                      borderRadius: BorderRadius.circular(12),
                      color: widget.classColor.shade50,
                      child: InkWell(
                        splashColor: Colors.grey.withAlpha(80),
                        onTap: () async {
                          final Uri url = Uri.parse(att.url);

                          try {
                            // 2. Tenta abrir a URL
                            // O `launchUrl` retorna um booleano: true se conseguiu, false se não.
                            if (!await launchUrl(url)) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  "Não foi possível abrir este arquivo",
                                  style:
                                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: cColorError,
                              ));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Erro: $e",
                                style:
                                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: cColorError,
                            ));
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: widget.classColor.shade200, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              HugeIcon(icon: HugeIcons.strokeRoundedDocumentAttachment, color: widget.classColor.shade900, size: 20,),
                              Flexible(
                                child: Text(att.filename, style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  
                                ), overflow: TextOverflow.ellipsis, maxLines: 1,),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).toList(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
