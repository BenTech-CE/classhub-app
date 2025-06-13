import 'package:classhub/core/utils/mural_type.dart';
import 'package:image_picker/image_picker.dart';

class MuralModel {
  final String? id;
  final MuralType type;
  final String description;
  final int subjectId;
  final List<XFile>? attachments;

  MuralModel({
    this.id,
    required this.type,
    required this.description,
    required this.subjectId,
    this.attachments,
  });

  factory MuralModel.fromJson(Map<String, dynamic> json) {
    return MuralModel(
      id: json['id'],
      type: json['type'] != null
          ? MuralType.getMuralTypeFromName(json['type']) ?? MuralType.AVISO
          : MuralType.AVISO,
      description: json['description'],
      subjectId: json['subjectId'],
    );
  }

  Map<String, String> toJson() {
    return {
      'type': type.name,
      'description': description,
      'subjectId': subjectId.toString(),
    };
  }
}
