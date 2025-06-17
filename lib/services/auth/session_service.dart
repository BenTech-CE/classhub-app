import 'dart:convert';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/auth/user_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart';

class SessionService {
  final http = Client();
  final AuthService authService;

  SessionService(this.authService);

  Future<UserModel?> getUser() async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse("${Api.baseUrl}${Api.sessionEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final UserModel um = UserModel.fromJson(jsonResponse);

      authService.mmkv.encodeString("classhub-user-id", um.id);
      authService.mmkv.encodeString("user.${um.id}", response.body);

      return um;
    } else {
      throw Exception(
          "Erro ao coletar as informações do usuário: ${jsonResponse["error"]}");
    }
  }

  UserModel? getCachedUser() {
    if (authService.mmkv.containsKey("user.${authService.getUserId()}")) {
      String userString =
          authService.mmkv.decodeString("user.${authService.getUserId()}")!;

      final UserModel um = UserModel.fromJson(jsonDecode(userString));

      return um;
    } else {
      return null;
    }
  }
}
