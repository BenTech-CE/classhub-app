class MinimalClassModel {
  final String id;
  final String name;
  final int color;
  final String school;

  MinimalClassModel({
    required this.id,
    required this.name,
    required this.color,
    required this.school
  });

  factory MinimalClassModel.fromJson(Map<String, dynamic> json) {
    return MinimalClassModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      school: json['school']
    );
  }
}
