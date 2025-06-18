import 'package:classhub/core/utils/mural_type.dart';
import 'package:classhub/models/class/mural/attachment_model.dart';
import 'package:classhub/models/class/mural/author_model.dart';
import 'package:classhub/models/class/mural/subject_mural_model.dart';
import 'package:intl/intl.dart';

class MuralModel {
  final String id;
  final MuralType type;
  final String description;
  final String createdAt;
  final List<AttachmentModel> attachments;
  final AuthorModel author;
  final SubjectMuralModel? subject;

  MuralModel({
    required this.id,
    required this.type,
    required this.description,
    required this.createdAt,
    required this.attachments,
    required this.author,
    this.subject,
  });

  factory MuralModel.fromJson(Map<String, dynamic> json) {
    var attachmentList = json['attachments'] as List;
    List<AttachmentModel> attachments = attachmentList.map((i) => AttachmentModel.fromJson(i)).toList();


    return MuralModel(
      id: json['id'],
      type:  MuralType.getMuralTypeFromName(json['type']) ?? MuralType.AVISO,
      description: json['description'],
      createdAt: json['created_at'],
      attachments: attachments,
      author: AuthorModel.fromJson(json['author']),
      subject: json['subject'] != null
        ? SubjectMuralModel.fromJson(json['subject'])
        : null,
    );
  }

  /// Formata a data de criação.
  /// Retorna "HH:mm" se a data for hoje.
  /// Retorna "dd/MM/yyyy" se a data não for hoje.
  String get formattedCreatedAt {
    // Pega a data e hora atual do dispositivo
    final now = DateTime.now();

    // 1. Converte a string da API para DateTime e depois para a hora local
    final dateFromApi = DateTime.parse(createdAt).toLocal();

    // 2. Verifica se a data da API é no mesmo dia que hoje
    final isSameDay = now.year == dateFromApi.year &&
        now.month == dateFromApi.month &&
        now.day == dateFromApi.day;

    // 3. Formata a string de acordo com a condição
    if (isSameDay) {
      // Se for hoje, formata como hora:minuto
      return DateFormat('HH:mm').format(dateFromApi);
    } else {
      // Se não for hoje, formata como dia/mês/ano
      return DateFormat('dd/MM/yyyy').format(dateFromApi);
    }
  }
}
