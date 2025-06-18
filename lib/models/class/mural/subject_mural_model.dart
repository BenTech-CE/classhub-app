class SubjectMuralModel {
  String id;
  String title;
  int color;

  SubjectMuralModel({
    required this.id,
    required this.title,
    required this.color,
  });

  factory SubjectMuralModel.fromJson(Map<String, dynamic> json) {
    return SubjectMuralModel(
      id: json['id'],
      title: json['title'],
      color: json['color']
    );
  }
}
