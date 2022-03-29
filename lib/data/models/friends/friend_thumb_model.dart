import 'package:json_annotation/json_annotation.dart';

part 'friend_thumb_model.g.dart';

@JsonSerializable()
class FriendThumbModel {
  final String? type;
  final String? thumbnailUrl;

  FriendThumbModel({required this.type, required this.thumbnailUrl});

  factory FriendThumbModel.fromJson(Map<String, dynamic> json) =>
      _$FriendThumbModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendThumbModelToJson(this);
}


