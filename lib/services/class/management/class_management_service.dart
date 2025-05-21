import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ClassManagementService {
  // final http = Client();
  final AuthService authService;

  ClassManagementService(this.authService);

  Future<MinimalClassModel> createClass(ClassModel classModel) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    var uri = Uri.parse("${Api.baseUrl}${Api.createClassEndpoint}");

    Map<String, String> requestBody = classModel.toJson();
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $token"
    };

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);

    if (classModel.banner != null) {
      final Uint8List fileBytes =  await classModel.banner!.readAsBytes();
      final multipartFileBanner = http.MultipartFile.fromBytes('banner',  fileBytes, filename: classModel.banner!.name);
      request.files.add(multipartFileBanner);
    }

    var response = await request.send();

    final respStr = await response.stream.bytesToString();

    Map<String, dynamic> jsonResponse = jsonDecode(respStr);

    print(response.statusCode);
    print(jsonResponse);

    if (response.statusCode == 201) {
      return MinimalClassModel.fromJson(jsonResponse);
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

  Future<MinimalClassModel> joinClass(String idClass) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.post(
      Uri.parse(
          "${Api.baseUrl}${Api.getClassEndpoint}${Api.joinClassEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "invite_code": idClass
      })
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return MinimalClassModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          "Erro ao tentar entrar na turma: ${jsonResponse["error"]}");
    }
  }

  Future<bool> deleteClass(String idClass) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.delete(
      Uri.parse(
          "${Api.baseUrl}${Api.getClassEndpoint}/$idClass"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
    } else {
      throw Exception(
          "Erro ao tentar deletar a turma: ${jsonResponse["error"]}");
    }
    return true;
  }
}
