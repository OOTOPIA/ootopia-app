import 'package:json_annotation/json_annotation.dart';
import 'friend_model.dart';
part 'friends_data_model.g.dart';

@JsonSerializable()
class FriendsDataModel {
  int? total;
  List<FriendModel?>? friends;

  FriendsDataModel({
    required this.total,
    required this.friends
  });

  factory FriendsDataModel.fromJson(Map<String, dynamic> json) =>
      _$FriendsDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendsDataModelToJson(this);
}

