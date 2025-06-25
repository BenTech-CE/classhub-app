extension DateTimeComparison on DateTime {
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Retorna uma nova instância de [DateTime] com o horário zerado (meia-noite).
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  String formattedHHmm() {
    // padLeft(2, '0') adiciona um zero à esquerda se o número for menor que 10.
    final String hour = this.hour.toString().padLeft(2, '0');
    final String minute = this.minute.toString().padLeft(2, '0');
    
    return '$hour:$minute';
  }
}