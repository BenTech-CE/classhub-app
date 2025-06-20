import 'dart:async';

import 'package:classhub/core/theme/sizes.dart';
import 'package:classhub/core/utils/mural_type.dart';
import 'package:classhub/core/utils/role.dart';
import 'package:classhub/core/utils/util.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:classhub/viewmodels/class/mural/class_mural_viewmodel.dart';
import 'package:classhub/views/classes/widgets/new_post_widget.dart';
import 'package:classhub/views/classes/widgets/post_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassMuralView extends StatefulWidget {
  final MinimalClassModel mClassObj;

  const ClassMuralView({super.key, required this.mClassObj});

  @override
  State<ClassMuralView> createState() => _ClassMuralViewState();
}

class _ClassMuralViewState extends State<ClassMuralView> {
  Set<String> muralSelectedOption = {};

  int _currentPage = 1;
  bool _canLoadMore = false;
  bool _refreshingPage = false;

  late MaterialColor classColor;

  final _muralController = StreamController<List<MuralModel>>();
  final List<MuralModel> _posts = [];

  Future<void> _fetchMural() async {
    //final cmvm = context.read<ClassMuralViewModel>();

    try {
      _refreshingPage = true;

      final cmvm = context.read<ClassMuralViewModel>();
      final newPosts = await cmvm.getPosts(widget.mClassObj.id, _currentPage);

      if (newPosts.isEmpty && cmvm.error != null) {
        _muralController.addError(cmvm.error!);
      }

      if (newPosts.length < 10) {
        // Se a API retornou menos de 10 itens, assumimos que é a última página
        _canLoadMore = false;
      } else {
        _canLoadMore = true;
      }

      // Adiciona os novos posts à lista existente
      _posts.addAll(newPosts);
      
      // Adiciona a lista completa e atualizada ao stream, o que irá notificar o StreamBuilder
      if (!_muralController.isClosed) {
        _muralController.add(_posts);
      }
      
      _currentPage++;
      _refreshingPage = false;
    } catch (e, s) {
      if (!_muralController.isClosed) {
         _muralController.addError(e, s);
      }
    }
  }

  @override
  void initState() {
    super.initState();

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
          SegmentedButton<String>(
            style: SegmentedButton.styleFrom(
                selectedBackgroundColor: classColor.shade400,
                selectedForegroundColor: Colors.white,
                foregroundColor: classColor.shade800,
                side: BorderSide(color: classColor.shade300, width: 1)),
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: "avisos",
                label: Text('Avisos'),
              ),
              ButtonSegment<String>(
                value: "materiais",
                label: Text('Materiais'),
              ),
            ],
            selected: muralSelectedOption,
            showSelectedIcon: false,
            multiSelectionEnabled: false,
            emptySelectionAllowed: true,
            onSelectionChanged: (Set<String> newSelection) {
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
            padding: EdgeInsets.all(sPadding),
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
                  
                  if (_refreshingPage && _posts.length == 0) {
                    return const CircularProgressIndicator();
                  }

                  if (posts.isEmpty) {
                    return const Text('Nenhum post no mural.');
                  }

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: posts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      if (posts[index].type == MuralType.AVISO) {
                        return PostAlertWidget(
                          classColor: classColor, 
                          post: posts[index],
                          editable: widget.mClassObj.role >= Role.contribuidor,
                        );
                      } else if (posts[index].type == MuralType.MATERIAL) {
                        return PostAlertWidget(
                          classColor: classColor, 
                          post: posts[index],
                          editable: widget.mClassObj.role >= Role.contribuidor,
                        );
                      }

                      return PostAlertWidget(
                          classColor: classColor, 
                          post: posts[index],
                          editable: widget.mClassObj.role >= Role.contribuidor,
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
          if (_posts.length >= 10 &&_canLoadMore)
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: sPadding),
              child: OutlinedButton(
                onPressed: () {
                  _fetchMural();
                }, 
                child: _refreshingPage ? Container(width: 16, height: 16, child: const CircularProgressIndicator(strokeWidth: 1,)) : const Text("Carregar mais postagens"),
              ),
            )
        ],
      ),
    );
  }
}
