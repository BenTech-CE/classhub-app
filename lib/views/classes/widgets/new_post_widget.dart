import 'dart:collection';

import 'package:classhub/core/theme/colors.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<String> tiposPost = <String>['Aviso','Material'];

class NewPostWidget extends StatefulWidget {
  final MaterialColor classColor;

  const NewPostWidget({super.key, required this.classColor});

  @override
  State<NewPostWidget> createState() => _NewPostWidgetState();
}

class _NewPostWidgetState extends State<NewPostWidget> {
  final List<DropdownMenuEntry<String>> dropTiposEntries = UnmodifiableListView<DropdownMenuEntry<String>>(
    tiposPost.map<DropdownMenuEntry<String>>((String name) => DropdownMenuEntry<String>(value: name, label: name)),
  );
  
  String dropTipos = tiposPost.first;

  late String uname;

  @override
  void initState() {
    super.initState();

    final uvm = context.read<UserViewModel>();
    uname = uvm.user!.name;
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
            backgroundColor: widget.classColor, radius: 22,
            foregroundImage: NetworkImage("https://ui-avatars.com/api/?name=$uname&background=random"),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.classColor.shade300, width: 2)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintText: "O que você deseja postar?",
                              hintStyle:
                                  TextStyle(color: cColorText3, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: widget.classColor.shade300,
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Row(
                      children: [
                        DropdownMenu<String>(
                          initialSelection: tiposPost.first,
                          onSelected: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropTipos = value!;
                            });
                          },
                          dropdownMenuEntries: dropTiposEntries,
                        )
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
