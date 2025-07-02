import 'dart:convert';
import 'dart:typed_data';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/management/class_model.dart';
import 'package:classhub/models/class/management/minimal_class_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:classhub/services/class/notifications/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:mmkv/mmkv.dart';

class ClassManagementService {
  final NotificationService notificationService = NotificationService();
  final AuthService authService;
  var mmkv = MMKV.defaultMMKV();

  ClassManagementService(this.authService);

  Future<MinimalClassModel> createClass(ClassModel classModel) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    var uri = Uri.parse("${Api.baseUrl}${Api.classEndpoint}");

    Map<String, String> requestBody = classModel.toJson();
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $token"
    };

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);

    if (classModel.banner != null) {
      final Uint8List fileBytes = await classModel.banner!.readAsBytes();
      final multipartFileBanner = http.MultipartFile.fromBytes(
          'banner', fileBytes,
          filename: classModel.banner!.name);
      request.files.add(multipartFileBanner);
    }

    var response = await request.send();

    final respStr = await response.stream.bytesToString();

    Map<String, dynamic> jsonResponse = jsonDecode(respStr);

    print(response.statusCode);
    print(jsonResponse);

    if (response.statusCode == 201) {
      authService.mmkv.encodeString(
          "${authService.getUserId()}.minimalclass.${jsonResponse["id"]}",
          respStr);

      return MinimalClassModel.fromJson(jsonResponse);
    } else {
      throw Exception("Erro ao criar a turma: ${jsonResponse["error"]}");
    }
  }

  Future<MinimalClassModel> editClass(ClassModel classModel) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    var uri = Uri.parse("${Api.baseUrl}${Api.classEndpoint}/${classModel.id}");

    Map<String, String> requestBody = classModel.toJson();
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $token"
    };

    var request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);

    if (classModel.banner != null) {
      print("ADding banner to class request..");
      final Uint8List fileBytes = await classModel.banner!.readAsBytes();
      final multipartFileBanner = http.MultipartFile.fromBytes(
          'banner', fileBytes,
          filename: classModel.banner!.name);
      request.files.add(multipartFileBanner);
    }

    var response = await request.send();

    final respStr = await response.stream.bytesToString();

    Map<String, dynamic> jsonResponse = jsonDecode(respStr);

    print(response.statusCode);
    print(jsonResponse);

    if (response.statusCode == 200) {
      authService.mmkv.encodeString(
          "${authService.getUserId()}.minimalclass.${jsonResponse["id"]}",
          respStr);

      return MinimalClassModel.fromJson(jsonResponse);
    } else {
      throw Exception("Erro ao editar a turma: ${jsonResponse["error"]}");
    }
  }

  Future<ClassModel> getClass(String idClass) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse("${Api.baseUrl}${Api.classEndpoint}/$idClass"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final ClassModel cm = ClassModel.fromJson(jsonResponse);
      authService.mmkv.encodeString(
          "${authService.getUserId()}.class.${cm.id}", response.body);
      return cm;
    } else {
      throw Exception(
          "Erro ao tentar acessar as informações da turma: ${jsonResponse["error"]}");
    }
  }

  Future<MinimalClassModel> joinClass(String idClass) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final fcmToken = await notificationService.getFcmToken();
    if (fcmToken == null) throw Exception('FCM Token não encontrado');

    final response = await http.post(
        Uri.parse("${Api.baseUrl}${Api.classEndpoint}${Api.joinClassEndpoint}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"invite_code": idClass, "fcm_token": fcmToken}));

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      authService.mmkv.encodeString(
          "${authService.getUserId()}.minimalclass.${jsonResponse["id"]}",
          response.body);

      return MinimalClassModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          "Erro ao tentar entrar na turma: ${jsonResponse["error"]}");
    }
  }

  Future<bool> deleteClass(String idClass) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.delete(
      Uri.parse("${Api.baseUrl}${Api.classEndpoint}/$idClass"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      authService.mmkv
          .removeValue("${authService.getUserId()}.minimalclass.$idClass");
      authService.mmkv.removeValue("${authService.getUserId()}.class.$idClass");
    } else {
      throw Exception(
          "Erro ao tentar deletar a turma: ${jsonResponse["error"]}");
    }
    return true;
  }

  ClassModel? getCachedClass(String idClass) {
    final sbjString = authService.mmkv
        .decodeString("${authService.getUserId()}.class.$idClass");

    if (sbjString == null) return null;

    ClassModel json = ClassModel.fromJson(jsonDecode(sbjString));

    return json;
  }
}
