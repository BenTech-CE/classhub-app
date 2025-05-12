import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/services/class/management/class_management_service.dart';
import 'package:flutter/material.dart';

class ClassManagementViewModel extends ChangeNotifier {
  final ClassManagementService classManagementService;
  bool isLoading = false;
  String? error;

  ClassManagementViewModel(this.classManagementService);

  Future<ClassModel?> createClass(ClassModel classModel) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classManagementService.createClass(classModel);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<ClassModel?> getClass(String idClass) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classManagementService.getClass(idClass);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<bool> joinClass(String idClass) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classManagementService.joinClass(idClass);
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
