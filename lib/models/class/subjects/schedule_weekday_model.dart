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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleWeekday &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;
}