// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    photoUrl: json['photoUrl'] as String?,
    type: _$enumDecode(_$NotificationTypeEnumMap, json['type']),
    typeId: json['typeId'] as String,
    userName: json['userName'] as String,
    userId: json['userId'] as String,
    amount: json['amount'] as int?,
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'photoUrl': instance.photoUrl,
      'type': _$NotificationTypeEnumMap[instance.type],
      'typeId': instance.typeId,
      'userName': instance.userName,
      'userId': instance.userId,
      'amount': instance.amount,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$NotificationTypeEnumMap = {
  NotificationType.comments: 'comments',
  NotificationType.gratitude_reward: 'gratitude_reward',
};
