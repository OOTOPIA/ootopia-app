// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) {
  return FriendModel(
    id: json['id'] as String,
    friendsThumbs: (json['friendsThumbs'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : FriendThumbModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    fullname: json['fullname'] as String?,
    photoUrl: json['photoUrl'] as String?,
    city: json['city'] as String?,
    state: json['state'] as String?,
    isFriend: json['isFriend'] as bool?,
    country: json['country'] as String?,
  )..remove = json['remove'] as bool?;
}

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendsThumbs': instance.friendsThumbs,
      'fullname': instance.fullname,
      'photoUrl': instance.photoUrl,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'isFriend': instance.isFriend,
      'remove': instance.remove,
    };
