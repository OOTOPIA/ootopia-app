import 'package:json_annotation/json_annotation.dart';

import 'friend_thumb_model.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
  final String id;
  @JsonKey(name: 'create_at')
  final String createAt;
  List<FriendThumbModel>? friendsThumbs;
  final String? fullname;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  final String? city;
  final String? state;
  final String? country;

  FriendModel({
    required this.id,
    required this.createAt,
    this.friendsThumbs,
    this.fullname,
    this.photoUrl,
    this.city,
    this.state,
    this.country, });

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);
}


