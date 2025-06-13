import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:classhub/services/class/management/class_management_service.dart';
import 'package:classhub/services/class/mural/class_mural_service.dart';
import 'package:flutter/material.dart';

class ClassMuralViewModel extends ChangeNotifier {
  final ClassMuralService classMuralService;
  bool isLoading = false;
  String? error;

  ClassMuralViewModel(this.classMuralService);

  Future<MuralModel?> createPost(String classId, MuralModel muralModel) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classMuralService.createPost(classId, muralModel);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<bool> deletePost(String classId, String postId) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classMuralService.deletePost(classId, postId);
    } catch (e) {
      print(e);
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
