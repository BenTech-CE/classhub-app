import 'package:classhub/core/utils/mural_type.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostMuralModel {
  final String? id;
  final MuralType type;
  final String description;
  final String? subjectId;
  final List<XFile>? attachments;

  CreatePostMuralModel({
    this.id,
    required this.type,
    required this.description,
    this.subjectId,
    this.attachments,
  });

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
