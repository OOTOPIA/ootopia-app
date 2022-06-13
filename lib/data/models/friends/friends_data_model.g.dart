// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendsDataModel _$FriendsDataModelFromJson(Map<String, dynamic> json) =>
    FriendsDataModel(
      total: json['total'] as int?,
      friends: (json['friends'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : FriendModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      searchFriends: (json['searchFriends'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : FriendModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..alreadyFriends = (json['alreadyFriends'] as List<dynamic>?)
        ?.map((e) =>
            e == null ? null : FriendModel.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$FriendsDataModelToJson(FriendsDataModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'friends': instance.friends,
      'alreadyFriends': instance.alreadyFriends,
      'searchFriends': instance.searchFriends,
    };
