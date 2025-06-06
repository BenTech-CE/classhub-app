import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/services/class/subjects/class_subjects_service.dart';
import 'package:flutter/material.dart';

class ClassSubjectsViewModel extends ChangeNotifier {
  final ClassSubjectsService classSubjectsService;
  bool isLoading = false;
  String? error;

  ClassSubjectsViewModel(this.classSubjectsService);

  Future<SubjectModel?> createSubject(
      String idClass, SubjectModel subjectModel) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classSubjectsService.createSubject(idClass, subjectModel);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<SubjectModel?> editSubject(
      String idClass, SubjectModel subjectModel) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classSubjectsService.editSubject(idClass, subjectModel);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<bool> deleteSubject(String idClass, String idSubject) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classSubjectsService.deleteSubject(idClass, idSubject);
    } catch (e) {
      print(e);
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<SubjectModel>> getSubjects(String idClass, {bool changeLoadingState = true}) async {
    if (changeLoadingState) isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classSubjectsService.getSubjects(idClass);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return [];
  }

  List<SubjectModel> getCachedSubjects(String idClass) {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return classSubjectsService.getCachedSubjects(idClass);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return [];
  }
}
