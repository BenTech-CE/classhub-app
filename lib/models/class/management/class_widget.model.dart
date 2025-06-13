class ClassWidgetModel {
  final String? id;
  final String title;
  final String description;

  ClassWidgetModel({
    this.id,
    required this.title,
    required this.description,
  });

  factory ClassWidgetModel.fromJson(Map<String, dynamic> json) {
    return ClassWidgetModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, String> toJson() {
    return {'title': title, 'description': description};
  }
}
