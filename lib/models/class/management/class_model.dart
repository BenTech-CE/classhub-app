import 'dart:typed_data';

import 'package:classhub/models/class/management/class_owner_model.dart';
import 'package:image_picker/image_picker.dart';

class ClassModel {
  final String? id;
  final String name;
  final int? inviteCode;
  final int? color;
  final String? bannerUrl;
  final XFile? banner;
  final String school;
  final ClassOwnerModel? owner;

  ClassModel({
    this.id,
    required this.name,
    this.inviteCode,
    this.color,
    this.bannerUrl,
    this.banner,
    required this.school,
     this.owner,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      inviteCode: json['invite_code'],
      color: json['color'],
      bannerUrl: json['banner_url'],
      school: json['school'],
      owner: ClassOwnerModel.fromJson(json['owner']),
    );
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      if (color != null) 'color': color.toString(),
      'school': school,
    };
  }
}
