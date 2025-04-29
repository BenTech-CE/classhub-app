import 'package:classhub/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService authService;
  bool isLoading = false;
  String? error;

  AuthViewModel(this.authService);

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      return await authService.login(email, password);
    } catch (e) {
      print(e);
      error = e.toString().replaceAll("Exception:", "");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
