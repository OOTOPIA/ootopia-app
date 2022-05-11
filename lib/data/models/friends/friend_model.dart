import 'package:json_annotation/json_annotation.dart';

import 'friend_thumb_model.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
  final String id;
  List<FriendThumbModel?>? friendsThumbs;
  final String? fullname;
  final String? photoUrl;
  final String? city;
  final String? state;
  final String? country;
  bool? isFriend;
  bool? isContact;
  bool? remove = false;

  FriendModel({
    required this.id,
    this.friendsThumbs,
    this.fullname,
    this.photoUrl,
    this.city,
    this.state,
    this.isFriend,
    this.country,
    this.isContact,
  });

  String location() {
    if ((state?.isNotEmpty ?? false) && (country?.isNotEmpty ?? false)) {
      return '$state - $country';
    } else if ((state?.isNotEmpty ?? false)) {
      return state!;
    } else if ((country?.isNotEmpty ?? false)) {
      return country!;
    }
    return '';
  }

  int amountOfPhotos() {
    if (friendsThumbs!.length > 4) {
      return 4;
    }
    return friendsThumbs!.length;
  }

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);
}
