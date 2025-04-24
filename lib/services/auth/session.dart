import 'package:classhub/models/auth/User.dart';
import 'package:classhub/services/auth/auth.dart';

class SessionService {
  final AuthService authService;

  SessionService(this.authService);

  Future<UserModel> getUser() async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      id: "12345",
      nome: "Ismael Nascimento",
      email: "ismael.nascimento@gmail.com",
      turmas: [],
    );
  }
}
