// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    photoURL: json['photoURL'] as String?,
    type: json['type'] as String,
    usersName:
        (json['usersName'] as List<dynamic>?)?.map((e) => e as String).toList(),
    postId: json['postId'] as String,
    userCommentFullname: json['userCommentFullname'] as String?,
    oozAmount: json['oozAmount'] as String?,
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'photoURL': instance.photoURL,
      'type': instance.type,
      'usersName': instance.usersName,
      'postId': instance.postId,
      'userCommentFullname': instance.userCommentFullname,
      'oozAmount': instance.oozAmount,
    };
