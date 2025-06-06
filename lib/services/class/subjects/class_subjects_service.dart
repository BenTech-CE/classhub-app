import 'dart:convert';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/subjects/subject_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart';

class ClassSubjectsService {
  final http = Client();
  final AuthService authService;

  ClassSubjectsService(this.authService);

  Future<SubjectModel> createSubject(
      String idClass, SubjectModel subjectModel) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.post(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.subjectEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(subjectModel.toJson()),
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SubjectModel.fromJson(jsonResponse);
    } else {
      throw Exception("Erro ao criar a matéria: ${jsonResponse["error"]}");
    }
  }

  Future<SubjectModel> editSubject(
      String idClass, SubjectModel subjectModel) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.put(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.subjectEndpoint}/${subjectModel.id}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(subjectModel.toJson()),
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return SubjectModel.fromJson(jsonResponse);
    } else {
      throw Exception("Erro ao editar a matéria: ${jsonResponse["error"]}");
    }
  }

  Future<SubjectModel> getSubject(String idClass, String idSubject) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.subjectEndpoint}/$idSubject"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return SubjectModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          "Erro ao tentar acessar a matéria: ${jsonResponse["error"]}");
    }
  }

  Future<bool> deleteSubject(String idClass, String idSubject) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.delete(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.subjectEndpoint}/$idSubject"),
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
      throw Exception("Erro ao deletar a matéria: ${jsonResponse["error"]}");
    }
  }

  Future<List<SubjectModel>> getSubjects(String idClass) async {
    final token = await authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.subjectEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      authService.mmkv.encodeString("${authService.getUserId()}.class.$idClass.subjects", response.body);

      List<SubjectModel> subjects = [];
      for (var subject in jsonResponse['subjects']) {
        subjects.add(SubjectModel.fromJson(subject));
      }
      return subjects;
    } else {
      throw Exception(
          "Erro ao tentar acessar as matérias: ${jsonResponse["error"]}");
    }
  }

  List<SubjectModel> getCachedSubjects(String idClass) {
      final sbjString = authService.mmkv.decodeString("${authService.getUserId()}.class.$idClass.subjects");

      if (sbjString == null) return [];

      List<SubjectModel> subjects = [];
      for (var subject in jsonDecode(sbjString)['subjects']) {
        subjects.add(SubjectModel.fromJson(subject));
      }
      return subjects;
  }
}
