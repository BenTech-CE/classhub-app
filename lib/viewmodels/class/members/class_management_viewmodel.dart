import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/services/class/management/class_management_service.dart';
import 'package:classhub/services/class/members/class_members_service.dart';
import 'package:flutter/material.dart';

class ClassMembersViewModel extends ChangeNotifier {
  final ClassMembersService classMembersService;
  bool isLoading = false;
  String? error;

  ClassMembersViewModel(this.classMembersService);

  Future<bool> deleteMember(String idClass, String idUser) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classMembersService.deleteMember(idClass, idUser);
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
