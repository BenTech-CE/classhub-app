import 'dart:convert';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart';

class ClassManagementService {
  final http = Client();
  final AuthService authService;

  ClassManagementService(this.authService);

  Future<ClassModel> createClass(ClassModel classModel) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.post(
      Uri.parse("${Api.baseUrl}${Api.createClassEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(classModel.toJson()),
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return ClassModel.fromJson(jsonResponse);
    } else {
      throw Exception("Erro ao criar a turma: ${jsonResponse["error"]}");
    }
  }

  Future<ClassModel> getClass(String idClass) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse("${Api.baseUrl}${Api.getClassEndpoint}/$idClass"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ClassModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          "Erro ao tentar acessar as informações da turma: ${jsonResponse["error"]}");
    }
  }

  Future<bool> joinClass(String idClass) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.post(
      Uri.parse(
          "${Api.baseUrl}${Api.getClassEndpoint}${Api.joinClassEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
    } else {
      throw Exception(
          "Erro ao tentar entrar na turma: ${jsonResponse["error"]}");
    }
    return true;
  }
}
