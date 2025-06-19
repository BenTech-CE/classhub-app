import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class MemberCardWidget extends StatelessWidget {
  final String name;
  final String role;
  final Color color;
  //final String iconeInicial;

  const MemberCardWidget({
    super.key,
    required this.name,
    required this.role,
    required this.color,
    //required this.iconeInicial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: sSpacing,
        children: [
          CircleAvatar(
            radius: 20, // Define o raio do círculo
            backgroundColor: color.withAlpha(100), // Define a cor de fundo
            child: Text(name[0],
                overflow: TextOverflow.clip,
                style: TextStyle(
                    color: color.withAlpha(255))), // Conteúdo dentro do círculo
          ),
          Expanded(
            //O Expanded ocupa todo o espaço possível, até o fim da linha. Assim, o IconButton fica lá no final - sem precisar de Spacer()!
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  role,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: cColorText1),
                ),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: cColorText1),
                  overflow: TextOverflow.fade, // faz "..." quando o texto for muito grande
                  maxLines: 1, // garante que o nome não quebre em várias linhas
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 24.0, color: Colors.black),
            onSelected: (String value) async {
              if (value == 'promo_lider') {
                //Função de Promover a Líder
              } else if (value == 'promo_vice') {
                //Função de Promover a Vice-Líder
              } else if (value == 'remove') {
                //Função de Remover da Turma
              }
            },
            itemBuilder: (BuildContext context) => popupMenuItemsLeader,
            // atention: Offset de onde irá aparecer o menu (x, y)
            offset: const Offset(-24, 24),
          )
        ],
      ),
    );
  }
}

final popupMenuItemsLeader = [
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
    child: Text('Remover'),
  )
];
