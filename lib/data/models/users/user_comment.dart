import 'package:json_annotation/json_annotation.dart';

part 'user_comment.g.dart';

@JsonSerializable()
class UserComment {
  String id;
  String fullname;
  String? email;
  String? photoUrl;

  UserComment({
    this.email,
    required this.fullname,
    required this.id,
    this.photoUrl,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) =>
      _$UserCommentFromJson(json);
}
