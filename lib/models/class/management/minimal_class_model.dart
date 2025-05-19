import 'package:classhub/core/utils/role.dart';

class MinimalClassModel {
  final String id;
  final String name;
  final int color;
  final String? bannerUrl;
  final String school;
  final Role role;

  MinimalClassModel({
    required this.id,
    required this.name,
    required this.color,
    this.bannerUrl,
    required this.school,
    required this.role
  });

  factory MinimalClassModel.fromJson(Map<String, dynamic> json) {
    return MinimalClassModel(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      bannerUrl: json['banner_url'],
      school: json['school'],
      role: Role.fromInt(json['role']) ?? Role.colega
    );
  }
}
