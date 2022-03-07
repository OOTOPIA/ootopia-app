import 'package:json_annotation/json_annotation.dart';

part 'user_comment.g.dart';

@JsonSerializable()
class UserSearchModel {
  String id;
  String fullname;
  String? email;
  String? photoUrl;

  UserSearchModel({
    this.email,
    required this.fullname,
    required this.id,
    this.photoUrl,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) =>
      _$UserSearchModelFromJson(json);
}
