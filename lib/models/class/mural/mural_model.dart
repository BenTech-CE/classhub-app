import 'package:classhub/models/class/mural/attachment_model.dart';
import 'package:classhub/models/class/mural/author_model.dart';
import 'package:classhub/models/class/mural/subject_mural_model.dart';

class MuralModel {
  final String? id;
  final String type;
  final String description;
  final String createdAt;
  final List<AttachmentModel>? attachments;
  final AuthorModel author;
  final SubjectMuralModel? subject;

  MuralModel({
    required this.id,
    required this.type,
    required this.description,
    required this.createdAt,
    this.attachments,
    required this.author,
    this.subject,
  });

  factory MuralModel.fromJson(Map<String, dynamic> json) {
    return MuralModel(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      createdAt: json['created_at'],
      attachments: (json['attachments'] as List?)
          ?.map((attachment) => AttachmentModel.fromJson(attachment))
          .toList(),
      author: AuthorModel.fromJson(json['author']),
      subject: SubjectMuralModel.fromJson(json['subject']),
    );
  }
}
