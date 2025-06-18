import 'dart:convert';
import 'dart:typed_data';

import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/mural/create_post_mural_model.dart';
import 'package:classhub/models/class/mural/mural_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:mmkv/mmkv.dart';

class ClassMuralService {
  final AuthService authService;
  var mmkv = MMKV.defaultMMKV();

  ClassMuralService(this.authService);

  Future<List<MuralModel>> getPosts(String classId, int page) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.get(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$classId${Api.muralEndpoint}?page=$page"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<MuralModel> posts = [];
      for (var post in jsonResponse['posts']) {
        posts.add(MuralModel.fromJson(post));
      }
      return posts;
    } else {
      throw Exception(
          "Erro ao tentar acessar os posts: ${jsonResponse["error"]}");
    }
  }

  Future<MuralModel> createPost(
      String classId, CreatePostMuralModel muralModel) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    var uri = Uri.parse(
        "${Api.baseUrl}${Api.classEndpoint}/$classId${Api.muralEndpoint}");

    Map<String, String> requestBody = muralModel.toJson();
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $token"
    };

    print(requestBody);

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..fields.addAll(requestBody);

    if (muralModel.attachments != null) {
      for (var attachment in muralModel.attachments!) {
        final Uint8List fileBytes = await attachment.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
            'attachments', fileBytes,
            filename: attachment.name);
        request.files.add(multipartFile);
      }
    }

    var response = await request.send();

    final respStr = await response.stream.bytesToString();

    Map<String, dynamic> jsonResponse = jsonDecode(respStr);

    print(response.statusCode);
    print(jsonResponse);

    if (response.statusCode == 200) {
      return MuralModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          "Erro ao criar o ${muralModel.type.type}: ${jsonResponse["error"]}");
    }
  }

  Future<bool> deletePost(String classId, String postId) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.delete(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$classId${Api.muralEndpoint}/$postId"),
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
          "Erro ao tentar deletar o post: ${jsonResponse["error"]}");
    }
  }
}
