import 'package:classhub/models/class/subjects/schedule_weekday_model.dart';
import 'package:flutter/material.dart';

double remap(
    double value, double min, double max, double targetMin, double targetMax) {
  double clampedValue = value.clamp(min, max);
  return targetMin +
      ((clampedValue - min) / (max - min)) * (targetMax - targetMin);
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: _tintColor(color, 0.9),
    100: _tintColor(color, 0.8),
    200: _tintColor(color, 0.6),
    300: _tintColor(color, 0.4),
    400: _tintColor(color, 0.2),
    500: color,
    600: _shadeColor(color, 0.1),
    700: _shadeColor(color, 0.2),
    800: _shadeColor(color, 0.3),
    900: _shadeColor(color, 0.4),
  });
}

Color _tintColor(Color color, double factor) => Color.fromRGBO(
      color.red + ((255 - color.red) * factor).round(),
      color.green + ((255 - color.green) * factor).round(),
      color.blue + ((255 - color.blue) * factor).round(),
      1,
    );

Color _shadeColor(Color color, double factor) => Color.fromRGBO(
      (color.red * (1 - factor)).round(),
      (color.green * (1 - factor)).round(),
      (color.blue * (1 - factor)).round(),
      1,
    );

double calculatePercentageWithReference(double refHeight, double refPerc, double currentScreenHeight) {
  final double referenceScreenHeight = refHeight;
  final double referencePercentage = refPerc;

  if (currentScreenHeight == referenceScreenHeight) {
    return referencePercentage;
  }

  final double ratio = currentScreenHeight / referenceScreenHeight;

  final double newPercentage = referencePercentage * ratio;

  return newPercentage;
}

List<Map<String, dynamic>> groupScheduleByTime(Map<String, ScheduleWeekday?> schedule) {
  final Map<ScheduleWeekday, List<String>> grouped = {};
  final dayOrder = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

  schedule.forEach((day, weekdaySchedule) {
    if (weekdaySchedule != null) {
      if (grouped.containsKey(weekdaySchedule)) {
        grouped[weekdaySchedule]!.add(day);
      } else {
        grouped[weekdaySchedule] = [day];
      }
    }
  });

  return grouped.entries.map((entry) {
    final weekdaySchedule = entry.key;
    final days = entry.value..sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));
    return {
      'days': days,
      'time': {
        'start_time': weekdaySchedule.startTime,
        'end_time': weekdaySchedule.endTime,
      },
    };
  }).toList();
}

List<Map<String, dynamic>> groupScheduleByLocation(Map<String, ScheduleWeekday?> schedule) {
  final Map<String, List<String>> grouped = {};
  final dayOrder = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

  schedule.forEach((day, weekdaySchedule) {
    if (weekdaySchedule != null) {
      if (grouped.containsKey(weekdaySchedule.location)) {
        grouped[weekdaySchedule.location]!.add(day);
      } else {
        grouped[weekdaySchedule.location] = [day];
      }
    }
  });

  return grouped.entries.map((entry) {
    final location = entry.key;
    final days = entry.value..sort((a, b) => dayOrder.indexOf(a).compareTo(dayOrder.indexOf(b)));
    return {
      'days': days,
      'location': location
    };
  }).toList();
}

String dayOfWeekAbbreviated(String dayOfWeek) {
  switch (dayOfWeek.toLowerCase()) {
    case 'monday':
      return 'Seg';
    case 'tuesday':
      return 'Ter';
    case 'wednesday':
      return 'Qua';
    case 'thursday':
      return 'Qui';
    case 'friday':
      return 'Sex';
    case 'saturday':
      return 'Sáb';
    case 'sunday':
      return 'Dom';
    default:
      return dayOfWeek; // Retorna o dia original se não houver tradução
  }
}

String dayOfWeekNormalized(String dayOfWeek) {
  switch (dayOfWeek.toLowerCase()) {
    case 'monday':
      return 'Segunda-feira';
    case 'tuesday':
      return 'Terça-feira';
    case 'wednesday':
      return 'Quarta-feira';
    case 'thursday':
      return 'Quinta-feira';
    case 'friday':
      return 'Sexta-feira';
    case 'saturday':
      return 'Sábado';
    case 'sunday':
      return 'Domingo';
    default:
      return dayOfWeek; // Retorna o dia original se não houver tradução
  }
}

String timeOfDayToString(TimeOfDay time) {
  final String hour = time.hour.toString().padLeft(2, '0');
  final String minute = time.minute.toString().padLeft(2, '0');
  
  return '$hour:$minute';
}

TimeOfDay? stringToTimeOfDay(String timeString) {
  try {
    final parts = timeString.split(':');
    if (parts.length != 2) {
      return null; 
    }

    final int? hour = int.tryParse(parts[0]);
    final int? minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return null;
    }

    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);

  } catch (e) {
    return null;
  }
}