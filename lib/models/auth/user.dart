class UserModel {
  final String? id;
  final String? nome;
  final String email;
  final List<Map<String, dynamic>>? turmas;

  UserModel({
    this.id,
    this.nome,
    required this.email,
    this.turmas,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'] ?? "",
      turmas: List<Map<String, dynamic>>.from(json['turmas']),
    );
  }
}
