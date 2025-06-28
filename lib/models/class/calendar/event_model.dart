class EventModel {
  final String? id;
  final String? createdAt;
  final String title;
  final String? description;
  final String? classId;
  String? startTime;
  String? endTime;
  final String date;
  final String? location;
  final bool isAllDay;
  final String? icon;

  EventModel({
    this.id,
    this.createdAt,
    required this.title,
    this.description,
    this.classId,
    this.startTime,
    this.endTime,
    required this.date,
    this.location,
    required this.isAllDay,
    this.icon,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      createdAt: json['created_at'],
      title: json['title'] ?? '',
      description: json['description'],
      classId: json['class_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      date: json['date'] ?? '',
      location: json['location'],
      isAllDay: json['is_all_day'] ?? false,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'title': title,
      'description': description,
      'class_id': classId,
      'start_time': startTime,
      'end_time': endTime,
      'date': date,
      'location': location,
      'is_all_day': isAllDay,
      'icon': icon,
    };
  }
}
