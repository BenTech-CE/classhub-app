enum Role {
  colega(0),
  criador(10),
  lider(5),
  viceLider(4);

  final int value;
  const Role(this.value);

  static Role? fromInt(int value) {
    try {
      return Role.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }

  String get name {
    return switch (value) {
      0 => "Colega",
      5 => "Líder",
      4 => "Vice-líder",
      10 => "Criador(a) da Turma",
      _ => "Colega",
    };
  }

  // Operador maior que (>)
  bool operator >(Role other) {
    return value > other.value;
  }

  // Operador menor que (<)
  bool operator <(Role other) {
    return value < other.value;
  }

  // Operador maior ou igual a (>=)
  bool operator >=(Role other) {
    return value >= other.value;
  }

  // Operador menor ou igual a (<=)
  bool operator <=(Role other) {
    return value <= other.value;
  }
}
