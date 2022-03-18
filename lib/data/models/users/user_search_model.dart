import 'package:json_annotation/json_annotation.dart';

part 'user_search_model.g.dart';

@JsonSerializable()
class UserSearchModel {
  String id;
  String fullname;
  String? email;
  String? photoUrl;
  int? start;
  int? end;

  UserSearchModel({
    this.email,
    required this.fullname,
    required this.id,
    this.photoUrl,
    this.start,
    this.end,
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json) =>
      _$UserSearchModelFromJson(json);
}
