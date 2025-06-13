enum MuralType {
  AVISO("aviso"),
  MATERIAL("material");

  final String type;

  const MuralType(this.type);

  static MuralType? getMuralTypeFromName(String type) {
    for (var muralType in MuralType.values) {
      if (muralType.type == type.toLowerCase()) {
        return muralType;
      }
    }
    return null;
  }
}
