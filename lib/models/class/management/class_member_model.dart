import 'package:classhub/core/utils/role.dart';

class ClassMemberModel {
  final String id;
  final String name;
  final String profilePicture;
  final Role role;

  ClassMemberModel({
    required this.id,
    required this.name,
    required this.profilePicture,
    required this.role
  });

  factory ClassMemberModel.fromJson(Map<String, dynamic> json) {
    return ClassMemberModel(
      id: json['id'],
      name: json['name'],
      profilePicture: json['profile_picture'] ?? "https://ui-avatars.com/api/?name=${json['name']}&background=random",
      role: Role.fromInt(json['role']) ?? Role.colega
    );
  }
  
}
