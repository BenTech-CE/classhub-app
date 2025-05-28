import 'dart:convert';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

class ClassMembersService {
  final AuthService authService;

  ClassMembersService(this.authService);

  Future<bool> deleteMember(String idClass, String idUser) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.delete(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.membersClassEndpoint}/$idUser"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          "Erro ao tentar sair da turma/remover membro: ${jsonResponse["error"]}");
    }
  }
}
