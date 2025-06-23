import 'dart:convert';
import 'package:classhub/core/utils/api.dart';
import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:mmkv/mmkv.dart';

class ClassCalendarService {
  final AuthService authService;
  var mmkv = MMKV.defaultMMKV();

  ClassCalendarService(this.authService);

  Future<List<EventModel>> getEvents(String classId, String? upcoming) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final Uri url = upcoming != null
        ? Uri.parse(
            "${Api.baseUrl}${Api.classEndpoint}/$classId${Api.calendarEndpoint}?upcoming=$upcoming")
        : Uri.parse(
            "${Api.baseUrl}${Api.classEndpoint}/$classId${Api.calendarEndpoint}");

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<EventModel> posts = [];
      for (var post in jsonResponse['events']) {
        posts.add(EventModel.fromJson(post));
      }
      return posts;
    } else {
      throw Exception(
          "Erro ao tentar acessar os eventos do calendário: ${jsonResponse["error"]}");
    }
  }

  Future<EventModel?> createEvent(String idClass, EventModel eventModel) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.post(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$idClass${Api.calendarEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(eventModel.toJson()),
    );

    print(response.statusCode);
    print(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return EventModel.fromJson(jsonResponse);
    } else {
      throw Exception(
          "Erro ao criar o evento no calendário: ${jsonResponse["error"]}");
    }
  }

  Future<bool> deleteEvent(String classId, String eventId) async {
    final token = authService.getToken();
    if (token == null) throw Exception('Token não encontrado');

    final response = await http.delete(
      Uri.parse(
          "${Api.baseUrl}${Api.classEndpoint}/$classId${Api.calendarEndpoint}/$eventId"),
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
          "Erro ao tentar deletar o evento: ${jsonResponse["error"]}");
    }
  }
}
