// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchModel _$UserSearchModelFromJson(Map<String, dynamic> json) {
  return UserSearchModel(
    email: json['email'] as String?,
    fullname: json['fullname'] as String,
    id: json['id'] as String,
    photoUrl: json['photoUrl'] as String?,
  );
}

Map<String, dynamic> _$UserSearchModelToJson(UserSearchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
    };
