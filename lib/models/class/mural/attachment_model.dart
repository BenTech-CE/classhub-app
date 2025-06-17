class AttachmentModel {
  final String id;
  final String url;
  final String postId;
  final String filename;

  AttachmentModel({
    required this.id,
    required this.url,
    required this.postId,
    required this.filename,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'],
      url: json['url'],
      postId: json['post_id'],
      filename: json['filename'],
    );
  }
}
