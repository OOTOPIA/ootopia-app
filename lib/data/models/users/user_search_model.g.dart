// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSearchModel _$UserSearchModelFromJson(Map<String, dynamic> json) {
  return UserSearchModel(
    email: json['email'] as String?,
    fullname: json['fullname'] as String,
    id: json['id'] as String,
    photoUrl: json['photoUrl'] as String?,
    start: json['start'] as int?,
    end: json['end'] as int?,
  );
}

Map<String, dynamic> _$UserSearchModelToJson(UserSearchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'start': instance.start,
      'end': instance.end,
    };
