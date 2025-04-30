class UserModel {
  final String id;
  final String name;
  final String email;
  final List<Map<String, dynamic>>
      classes; // É uma lista de um mapa em que as chaves são string e os valores são dinâmicos. Agora o porquê de ser lista nem eu entendi.

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.classes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {//
    return UserModel(
      id: json['id'], // Acessando o valor cuja chave é 'id'!
      name: json['name'],
      email: json['email'] ?? "",
      classes: List<Map<String, dynamic>>.from(json['classes']),
    );
  }
}
