import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/class_member_model.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/viewmodels/class/members/class_members_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MemberCardWidget extends StatefulWidget {
  final ClassMemberModel member;
  final String classId;
  final MaterialColor color;
  final Role myRole;
  final VoidCallback onChanged;

  const MemberCardWidget({
    super.key,
    required this.member,
    required this.color,
    required this.classId,
    required this.myRole,
    required this.onChanged
  });

  @override
  State<MemberCardWidget> createState() => _MemberCardWidgetState();
}

class _MemberCardWidgetState extends State<MemberCardWidget> {
  final popupMenuItemsOwner = [
    const PopupMenuItem<String>(
      value: 'promo_lider',
      child: Text('Promover a Líder'),
    ),
    const PopupMenuItem<String>(
      value: 'promo_vice',
      child: Text('Promover a Vice-Líder'),
    ),
    const PopupMenuItem<String>(
      value: 'remove',
      child: Text('Expulsar'),
    )
  ];

  final popupMenuItemsLeader = [
    const PopupMenuItem<String>(
      value: 'promo_vice',
      child: Text('Promover a Vice-Líder'),
    ),
    const PopupMenuItem<String>(
      value: 'remove',
      child: Text('Expulsar'),
    )
  ];

  final popupMenuItemsVice = [
    const PopupMenuItem<String>(
      value: 'remove',
      child: Text('Expulsar'),
    )
  ];

  void _kick() async {
    final cmvm = context.read<ClassMembersViewModel>();

    final result = await cmvm.deleteMember(widget.classId, widget.member.id);

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Não foi possível expulsar este colega.",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cColorError,
      ));
    } else {
      widget.onChanged();
    }
  }

  void _promoLider() {

  }

  void _promoVice() {

  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: sSpacing,
        children: [
          CircleAvatar(
            radius: 20, // Define o raio do círculo
            backgroundColor: widget.color.shade100, // Define a cor de fundo
            child: Text(
              getNameInitials(widget.member.name),
              overflow: TextOverflow.clip,
              style: TextStyle(color: widget.color),
            ), // Conteúdo dentro do círculo
          ),
          Expanded(
            //O Expanded ocupa todo o espaço possível, até o fim da linha. Assim, o IconButton fica lá no final - sem precisar de Spacer()!
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.member.role.name,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: cColorText1),
                ),
                Text(
                  widget.member.name,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: cColorText1),
                  overflow: TextOverflow.ellipsis, // faz "..." quando o texto for muito grande
                  maxLines: 1, // garante que o nome não quebre em várias linhas
                ),
              ],
            ),
          ),
          if (widget.myRole >= Role.viceLider && widget.myRole > widget.member.role)
            SizedBox(
              height: 24,
              width: 24,
              child: PopupMenuButton<String>(
                shadowColor: Colors.grey, // Drop shadow do popup menu
                menuPadding: EdgeInsets.zero, // Retirando os respiros verticais (dentro do menu) que vem por padrão
                padding: EdgeInsets.zero, // Retirando os respiros padrões (do IconButton)
                icon: const Icon(Icons.more_vert, size: 24.0, color: Colors.black),
                onSelected: (String value) async {
                  if (value == 'promo_lider') {
                    _promoLider();
                  } else if (value == 'promo_vice') {
                    _promoVice();
                  } else if (value == 'remove') {
                    _kick();
                  }
                },
                itemBuilder: (BuildContext context) {
                  switch (widget.myRole) {
                    case Role.criador:
                      return popupMenuItemsOwner;
                    case Role.lider:
                      return popupMenuItemsLeader;
                    case Role.viceLider:
                      return popupMenuItemsVice;
                    default:
                      return [];
                  }
                },
                // atention: Offset de onde irá aparecer o menu (x, y)
                offset: const Offset(-16, 16),
              ),
            )
        ],
      ),
    );
  }
}