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
      error = null;
      return await authService.login(email, password);
    } catch (e) {
      print(e);
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await authService.register(name, email, password);
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
