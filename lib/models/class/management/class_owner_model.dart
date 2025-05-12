class ClassOwnerModel {
  final String id;
  final String name;

  ClassOwnerModel({
    required this.id,
    required this.name,
  });

  factory ClassOwnerModel.fromJson(Map<String, dynamic> json) {
    return ClassOwnerModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
