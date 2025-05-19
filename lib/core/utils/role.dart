enum Role {
  colega(0),
  lider(5),
  viceLider(4),
  contribuidor(3);

  final int value;
  const Role(this.value);

  static Role? fromInt(int value) {
    try {
      return Role.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
