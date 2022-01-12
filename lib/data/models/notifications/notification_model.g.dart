// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    photoUrl: json['photoUrl'] as String?,
    type: json['type'] as String,
    typeId: json['typeId'] as String,
    userName: json['userName'] as String,
    userId: json['userId'] as String,
    amount: json['amount'] as int?,
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'photoUrl': instance.photoUrl,
      'type': instance.type,
      'typeId': instance.typeId,
      'userName': instance.userName,
      'userId': instance.userId,
      'amount': instance.amount,
    };
