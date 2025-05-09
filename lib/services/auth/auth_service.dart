import 'dart:convert';

import 'package:classhub/core/utils/api.dart';
import 'package:http/http.dart';
import 'package:mmkv/mmkv.dart';

class AuthService {
  final http = Client();
  var mmkv = MMKV.defaultMMKV();

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${Api.baseUrl}${Api.loginEndpoint}"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      mmkv.encodeString("classhub-user-token", jsonResponse["token"]);
    } else {
      throw Exception("Erro ao fazer login: ${jsonResponse["error"]}");
    }

    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse("${Api.baseUrl}${Api.registerEndpoint}"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      mmkv.encodeString("classhub-user-token", jsonResponse["token"]);
    } else {
      throw Exception("Erro ao fazer o cadastro: ${jsonResponse["error"]}");
    }

    return true;
  }

  Future<String?> getToken() async {
    return mmkv.decodeString("classhub-user-token");
  }
}
