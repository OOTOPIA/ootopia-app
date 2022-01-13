// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    photoUrl: json['photoUrl'] as String?,
    type: json['type'] as String,
    usersName:
        (json['usersName'] as List<dynamic>).map((e) => e as String).toList(),
    postId: json['postId'] as String,
    oozAmount: json['oozAmount'] as int?,
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'photoUrl': instance.photoUrl,
      'type': instance.type,
      'usersName': instance.usersName,
      'postId': instance.postId,
      'oozAmount': instance.oozAmount,
    };
