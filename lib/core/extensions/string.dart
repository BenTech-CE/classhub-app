import 'package:classhub/core/extensions/date.dart';
import 'package:flutter/material.dart';



extension StringExtensions on String {
  String toCapitalized() {
    if (isEmpty) {
      return "";
    }
    
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  


  DateTime? toDate() {
    try {
      // DateTime.parse lida nativamente com o formato 'YYYY-MM-DD'.
      return DateTime.parse(this);
    } on FormatException {
      // Se a string não for uma data válida no formato esperado,
      // uma exceção é lançada. Nós a capturamos e retornamos null.
      debugPrint("Erro de formatação: A string '$this' não é uma data válida no formato YYYY-MM-DD.");
      return null;
    }
  }

  TimeOfDay? toTimeOfDay() {
    try {
      final parts = split(':');
      if (parts.length < 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }
}

/// Converte uma string de horário UTC (HH:mm:ss) para um horário local (HH:mm).
///
/// [utcTimeString] A string de horário em UTC, por exemplo "12:54:00".
/// Retorna a string formatada no fuso horário local, ou uma mensagem de erro se o formato for inválido.
String convertUtcTimeToLocalFormatted(String utcTimeString) {
  // 1. Converte a string de horário para um objeto TimeOfDay.
  final timeOfDay = utcTimeString.toTimeOfDay();

  if (timeOfDay == null) {
    return "Formato de hora inválido";
  }

  // 2. Cria uma data completa em UTC usando a data de hoje.
  // Isso é necessário para termos um objeto DateTime completo para a conversão de fuso.
  final now = DateTime.now();
  final utcDateTime = DateTime.utc(
    now.year,
    now.month,
    now.day,
    timeOfDay.hour,
    timeOfDay.minute,
  );

  // 3. Converte o DateTime de UTC para o fuso horário local do dispositivo.
  final localDateTime = utcDateTime.toLocal();

  // 4. Formata o DateTime local para a string "HH:mm" usando nossa extensão.
  return localDateTime.formattedHHmm();
}