import 'dart:async';

import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/mural_type.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:classhub/viewmodels/auth/user_viewmodel.dart';
import 'package:classhub/viewmodels/class/mural/class_mural_viewmodel.dart';
import 'package:classhub/views/classes/widgets/new_post_widget.dart';
import 'package:classhub/views/classes/widgets/post_alert_widget.dart';
import 'package:classhub/views/classes/widgets/post_material_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassMuralView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassMuralView({super.key, required this.mClassObj});

  @override
  State<ClassMuralView> createState() => _ClassMuralViewState();
}

class _ClassMuralViewState extends State<ClassMuralView> {
  Set<MuralType> muralSelectedOption = {};

  int _currentPage = 1;
  bool _canLoadMore = false;
  bool _refreshingPage = false;

  late MaterialColor classColor;

  late String userId;

  final _muralController = StreamController<List<MuralModel>>();
  final List<MuralModel> _posts = [];

  void _onPostDeleted() {
    setState(() {
      _posts.clear();
      _currentPage = 1;
      _canLoadMore = false;
    });

    _fetchMural();
  }

  Future<void> _fetchMural() async {
    //final cmvm = context.read<ClassMuralViewModel>();

    try {
      setState(() {
        _refreshingPage = true;
      });

      final cmvm = context.read<ClassMuralViewModel>();
      final newPosts = await cmvm.getPosts(widget.mClassObj.id, _currentPage);

      if (newPosts.isEmpty && cmvm.error != null) {
        _muralController.addError(cmvm.error!);
      }

      if (newPosts.length < 10) {
        // Se a API retornou menos de 10 itens, assumimos que é a última página

        setState(() {
          _canLoadMore = false;
        });
      } else {
        setState(() {
          _canLoadMore = true;
        });
      }

      // Adiciona os novos posts à lista existente
      _posts.addAll(newPosts);

      // Adiciona a lista completa e atualizada ao stream, o que irá notificar o StreamBuilder
      if (!_muralController.isClosed) {
        _muralController.add(_posts);
      }

      setState(() {
        _currentPage++;
        _refreshingPage = false;
      });
    } catch (e, s) {
      if (!_muralController.isClosed) {
        _muralController.addError(e, s);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final uvm = context.read<UserViewModel>();
    userId = uvm.user!.id;

    classColor = generateMaterialColor(Color(widget.mClassObj.color));

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchMural());
  }

  @override
  void dispose() {
    _muralController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final cmvm = context.watch<ClassMuralViewModel>();

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NewPostWidget(
            classColor: classColor,
            classId: widget.mClassObj.id,
            onCreated: () {
              setState(() {
                _posts.clear();
                _currentPage = 1;
              });
              _fetchMural();
            },
          ),
          SegmentedButton<MuralType>(
            style: SegmentedButton.styleFrom(
                selectedBackgroundColor: classColor.shade400,
                selectedForegroundColor: Colors.white,
                foregroundColor: classColor.shade800,
                side: BorderSide(color: classColor.shade300, width: 1)),
            segments: const [
              ButtonSegment(
                value: MuralType.AVISO,
                label: Text('Avisos'),
              ),
              ButtonSegment(
                value: MuralType.MATERIAL,
                label: Text('Materiais'),
              ),
            ],
            selected: muralSelectedOption,
            showSelectedIcon: false,
            multiSelectionEnabled: false,
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<MuralType> newSelection) {
              setState(() {
                // By default there is only a single segment that can be
                // selected at one time, so its value is always the first
                // item in the selected set.
                try {
                  muralSelectedOption = newSelection;
                } catch (_) {
                  muralSelectedOption = {};
                }
              });
            },
          ),
          Container(
            padding: const EdgeInsets.all(sPadding),
            alignment: Alignment.topCenter,
            child: StreamBuilder<List<MuralModel>>(
              stream: _muralController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  print(snapshot.stackTrace);
                  print(snapshot.error);

                  return Text(
                    'Ocorreu um erro: ${snapshot.error}',
                  );
                }

                if (snapshot.hasData) {
                  final posts = snapshot.data!;

                  final filteredPosts = muralSelectedOption.isEmpty
                      ? posts
                      : posts
                          .where((p) => muralSelectedOption.contains(p.type))
                          .toList();

                  if (_refreshingPage && _posts.isEmpty) {
                    return const CircularProgressIndicator();
                  }

                  if (filteredPosts.isEmpty) {
                    return const Text('Nenhum post no mural.');
                  }

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredPosts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      if (filteredPosts[index].type == MuralType.AVISO) {
                        return PostAlertWidget(
                          classId: widget.mClassObj.id,
                          classColor: classColor,
                          post: filteredPosts[index],
                          editable: widget.mClassObj.role >= Role.viceLider || filteredPosts[index].author.id == userId,
                          onDelete: _onPostDeleted,
                        );
                      } else if (filteredPosts[index].type ==
                          MuralType.MATERIAL) {
                        return PostMaterialWidget(
                          classId: widget.mClassObj.id,
                          classColor: classColor,
                          post: filteredPosts[index],
                          editable: widget.mClassObj.role >= Role.viceLider || filteredPosts[index].author.id == userId,
                          onDelete: _onPostDeleted,
                        );
                      }

                      return PostAlertWidget(
                        classId: widget.mClassObj.id,
                        classColor: classColor,
                        post: filteredPosts[index],
                        editable: widget.mClassObj.role >= Role.viceLider || filteredPosts[index].author.id == userId,
                        onDelete: _onPostDeleted,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 16);
                    },
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
          if (_posts.length >= 10 && _canLoadMore)
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: sPadding, right: sPadding, bottom: sPadding),
              child: OutlinedButton(
                onPressed: () {
                  _fetchMural();
                },
                child: _refreshingPage
                    ? Container(
                        width: 16,
                        height: 16,
                        child: const CircularProgressIndicator(strokeWidth: 1))
                    : const Text("Carregar mais postagens"),
              ),
            )
        ],
      ),
    );
  }
}
