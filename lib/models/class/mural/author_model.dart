class AuthorModel {
  final String id;
  final String name;
  final String profilePicture;

  AuthorModel({
    required this.id,
    required this.name,
    required this.profilePicture,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name'],
      profilePicture: json['profile_picture'] ?? '',
    );
  }
}
