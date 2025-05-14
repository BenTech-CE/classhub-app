class MinimalClassModel {
  final String id;
  final String name;
  final int color;
  final String school;
  final bool canEdit;

  MinimalClassModel({
    required this.id,
    required this.name,
    required this.color,
    required this.school,
    required this.canEdit
  });

  factory MinimalClassModel.fromJson(Map<String, dynamic> json) {
    return MinimalClassModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      school: json['school'],
      canEdit: json['can_edit']
    );
  }
}
