import 'package:classhub/models/class/mural/create_post_mural_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:classhub/services/class/mural/class_mural_service.dart';
import 'package:flutter/material.dart';

class ClassMuralViewModel extends ChangeNotifier {
  final ClassMuralService classMuralService;
  bool isLoading = false;
  String? error;

  ClassMuralViewModel(this.classMuralService);

  Future<List<MuralModel>> getPosts(String classId, int page) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classMuralService.getPosts(classId, page);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return [];
  }

  Future<List<MuralModel>> getPostsDoNotNotify(String classId, int page) async {
    return await classMuralService.getPosts(classId, page);
  }

  Future<MuralModel?> createPost(
      String classId, CreatePostMuralModel muralModel) async {
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
