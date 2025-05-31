import 'package:classhub/models/class/subjects/schedule_weekday_model.dart';

class SubjectModel {
  String id;
  String title;
  String? teacher;
  String? pud;
  final String? classId;
  Map<String, ScheduleWeekday?> schedule;
  int? color;

  SubjectModel({
    required this.id,
    required this.title,
    this.teacher,
    this.pud,
    this.classId,
    required this.schedule,
    this.color,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      title: json['title'],
      teacher: json['teacher'],
      pud: json['pud'],
      classId: json['class_id'],
      schedule: {
        'sunday': json['schedule']?['sunday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['sunday']),
        'monday': json['schedule']?['monday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['monday']),
        'tuesday': json['schedule']?['tuesday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['tuesday']),
        'wednesday': json['schedule']?['wednesday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['wednesday']),
        'thursday': json['schedule']?['thursday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['thursday']),
        'friday': json['schedule']?['friday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['friday']),
        'saturday': json['schedule']?['saturday'] == null ? null : ScheduleWeekday.fromJson(json['schedule']['saturday']),
      },
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'teacher': teacher,
      'pud': pud,
      'schedule': schedule.map((key, value) => MapEntry(key, value?.toJson())),
      'color': color,
    };
  }
}