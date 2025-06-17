class SubjectMuralModel {
  String id;
  String title;

  SubjectMuralModel({
    required this.id,
    required this.title,
  });

  factory SubjectMuralModel.fromJson(Map<String, dynamic> json) {
    return SubjectMuralModel(
      id: json['id'],
      title: json['title'],
    );
  }
}
