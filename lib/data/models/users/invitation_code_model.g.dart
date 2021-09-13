// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_code_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationCodeModel _$InvitationCodeModelFromJson(Map<String, dynamic> json) {
  return InvitationCodeModel(
    id: json['id'] as String,
    type: json['type'] as String,
    active: json['active'] as bool,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$InvitationCodeModelToJson(
        InvitationCodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'active': instance.active,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'code': instance.code,
    };
