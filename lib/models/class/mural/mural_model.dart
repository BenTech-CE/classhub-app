import 'package:classhub/core/utils/mural_type.dart';
import 'package:image_picker/image_picker.dart';

class MuralModel {
  final String? id;
  final MuralType type;
  final String description;
  final String? subjectId;
  final List<XFile>? attachments;

  MuralModel({
    this.id,
    required this.type,
    required this.description,
    this.subjectId,
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
    final Map<String, String> json = {
      'type': type.name,
      'description': description,
    };
    
    if (subjectId != null) {
      json['subjectId'] = subjectId!;
    }
    
    return json;
  }
}
