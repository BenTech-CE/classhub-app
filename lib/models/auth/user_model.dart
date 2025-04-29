class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final List<Map<String, dynamic>>? classes;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.classes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? "",
      classes: List<Map<String, dynamic>>.from(json['classes']),
    );
  }
}
