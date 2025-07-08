import 'package:classhub/core/utils/role.dart';
import 'package:classhub/models/class/management/class_member_model.dart';
import 'package:classhub/services/class/members/class_members_service.dart';
import 'package:flutter/material.dart';

class ClassMembersViewModel extends ChangeNotifier {
  final ClassMembersService classMembersService;

  bool _isLoading = false;
  List<ClassMemberModel> _members = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<ClassMemberModel> get members => _members;
  String? get error => _error;

  ClassMembersViewModel(this.classMembersService);

  Future<bool> deleteMember(String idClass, String idUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      _error = null;
      return await classMembersService.deleteMember(idClass, idUser);
    } catch (e) {
      print(e);
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getMembers(String classId) async {
    _isLoading = true;
    _members.clear();
    notifyListeners();

    try {
      _error = null;
      _members = await classMembersService.getMembers(classId);
    } catch (e) {
      print(e);
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return;
  }

  Future<bool> promoteOrDemoteMember(
      String classId, String userId, Role role) async {
    _isLoading = true;
    notifyListeners();

    try {
      _error = null;
      return await classMembersService.promoteOrDemoteMember(
          classId, userId, role);
    } catch (e) {
      print(e);
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
