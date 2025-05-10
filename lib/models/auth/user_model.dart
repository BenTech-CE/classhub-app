import 'package:classhub/models/class/minimal_class_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final List<MinimalClassModel>
      classes;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.classes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], // Acessando o valor cuja chave é 'id'!
      name: json['name'],
      email: json['email'] ?? "",
      classes: (json['classes'] as List<dynamic>)
          .map((e) => MinimalClassModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
