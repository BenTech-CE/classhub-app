import 'package:classhub/models/class/calendar/event_model.dart';
import 'package:classhub/services/class/calendar/class_calendar_service.dart';
import 'package:flutter/material.dart';

class ClassCalendarViewModel extends ChangeNotifier {
  final ClassCalendarService classCalendarService;
  bool isLoading = false;
  String? error;

  ClassCalendarViewModel(this.classCalendarService);

  Future<List<EventModel>> getEvents(String classId, String? upcoming) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classCalendarService.getEvents(classId, upcoming);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return [];
  }

  Future<EventModel?> createEvent(String idClass, EventModel eventModel) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classCalendarService.createEvent(idClass, eventModel);
    } catch (e) {
      print(e);
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<bool> deleteEvent(String classId, String eventId) async {
    isLoading = true;
    notifyListeners();

    try {
      error = null;
      return await classCalendarService.deleteEvent(classId, eventId);
    } catch (e) {
      print(e);
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
