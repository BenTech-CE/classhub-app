class UserModel {
  final String? id;
  final String? nome;
  final String email;
  final String? senha;
  final List<Map<String, dynamic>>? turmas;

  UserModel({
    this.id,
    this.nome,
    required this.email,
    this.senha,
    this.turmas,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'] ?? "",
      senha: json['senha'],
      turmas: List<Map<String, dynamic>>.from(json['turmas']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'turmas': turmas,
    };
  }
}
