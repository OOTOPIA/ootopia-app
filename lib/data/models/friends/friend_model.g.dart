// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendModel _$FriendModelFromJson(Map<String, dynamic> json) {
  return FriendModel(
    id: json['id'] as String,
    createAt: json['create_at'] as String,
    friendsThumbs: (json['friendsThumbs'] as List<dynamic>?)
        ?.map((e) => FriendThumbModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    fullname: json['fullname'] as String?,
    photoUrl: json['photo_url'] as String?,
    city: json['city'] as String?,
    state: json['state'] as String?,
    country: json['country'] as String?,
  );
}

Map<String, dynamic> _$FriendModelToJson(FriendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'create_at': instance.createAt,
      'friendsThumbs': instance.friendsThumbs,
      'fullname': instance.fullname,
      'photo_url': instance.photoUrl,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
    };
