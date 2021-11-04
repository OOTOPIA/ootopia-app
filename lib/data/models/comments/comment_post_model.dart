import 'package:json_annotation/json_annotation.dart';
part 'comment_post_model.g.dart';

@JsonSerializable()
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final String? photoUrl;
  final String? username;
  final bool deleted = false;
  final bool selected = false;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    this.photoUrl,
    required this.username,
    this.createdAt,
    this.updatedAt,
  });
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
