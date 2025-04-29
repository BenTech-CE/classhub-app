class UserModel {
  final String id;
  final String name;
  final String email;
  final List<Map<String, dynamic>> classes;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.classes,
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
