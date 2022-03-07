// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsDataModel _$FriendsDataModelFromJson(Map<String, dynamic> json) {
  return FriendsDataModel(
    length: json['length'] as int?,
    friends: (json['friends'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : FriendModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$FriendsDataModelToJson(FriendsDataModel instance) =>
    <String, dynamic>{
      'length': instance.length,
      'friends': instance.friends,
    };
