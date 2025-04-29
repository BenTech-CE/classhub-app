import 'package:classhub/models/auth/user_model.dart';
import 'package:classhub/services/auth/session_service.dart';
import 'package:flutter/material.dart';

class UserViewModel extends ChangeNotifier {
  final SessionService sessionService;
  UserModel? user;
  bool isLoading = false;
  String? error;

  UserViewModel(this.sessionService);

  Future<void> fetchUser() async {
    isLoading = true;
    notifyListeners();

    try {
      user = await sessionService.getUser();
      print(user!.name!);
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
