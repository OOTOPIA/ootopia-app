import 'package:json_annotation/json_annotation.dart';

part 'invitation_code_model.g.dart';

@JsonSerializable()
class InvitationCodeModel {
  String id;
  String type;
  bool active;
  String userId;
  String createdAt;
  String updatedAt;
  String code;

  InvitationCodeModel({
    required this.id,
    required this.type,
    required this.active,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.code,
  });

  factory InvitationCodeModel.fromJson(Map<String, dynamic> json) =>
      _$InvitationCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$InvitationCodeModelToJson(this);
}
