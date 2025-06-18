enum MuralType {
  AVISO("aviso"),
  MATERIAL("material");

  final String type;

  const MuralType(this.type);

  static MuralType? getMuralTypeFromName(String type) {
    try {
      return MuralType.values.firstWhere((e) => e.type == type);
    } catch (_) {
      return null;
    }
  }
}
