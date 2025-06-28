import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/viewmodels/class/members/class_members_viewmodel.dart';
import 'package:classhub/views/classes/widgets/member_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:classhub/core/theme/colors.dart';
import 'package:provider/provider.dart';

class ListMembersSheet extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ListMembersSheet({super.key, required this.mClassObj});

  @override
  State<ListMembersSheet> createState() => _ListMembersSheetState();
}

class _ListMembersSheetState extends State<ListMembersSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Chama a função do provider para buscar os dados.
      // Use 'listen: false' porque estamos apenas disparando uma ação,
      // não precisamos 'ouvir' mudanças dentro do initState.
      Provider.of<ClassMembersViewModel>(context, listen: false).getMembers(widget.mClassObj.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassMembersViewModel>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: sSpacing,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: sPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: sSpacing,
                children: [
                  Text(
                    "Lista de Colegas",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: cColorPrimary),
                    textAlign: TextAlign.center,
                  ),
                  if (!provider.isLoading&&provider.members.isNotEmpty)
                    Text(
                      "Mostrando ${provider.members.length} colegas em P5 - Informática",
                      style: const TextStyle(color: cColorText2Azul),
                      textAlign: TextAlign.left,
                    )
                ],
              ),
            ),
            Consumer<ClassMembersViewModel>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const CircularProgressIndicator();
        
                } else if (provider.error != null) {
                  return Text(provider.error!); // Exibe a mensagem de erro do provider
        
                } else if (provider.members.isEmpty) {
                  return const Text('Nenhum membro encontrado');
                }
        
                // Se tudo deu certo, use a lista de membros do provider
                final members = provider.members;
        
                return ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: members
                          .map(
                            (member) => MemberCardWidget(
                              member: member,
                              color: generateMaterialColor(cColorPrimary), 
                              myRole: widget.mClassObj.role
                            ),
                          )
                          .toList(),
                );
              },
            ),
            const SizedBox.shrink()
          ],
        ),
      )
    );
  }
}
