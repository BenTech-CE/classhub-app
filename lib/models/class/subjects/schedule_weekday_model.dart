class ScheduleWeekday {
  final String startTime;
  final String endTime;
  final String location;

  ScheduleWeekday({
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  factory ScheduleWeekday.fromJson(Map<String, dynamic> json) {
    return ScheduleWeekday(
      startTime: json['start_time'],
      endTime: json['end_time'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
    };
  }
}