import 'package:json_annotation/json_annotation.dart';

import 'friend_thumb_model.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class FriendModel {
  final String? id;
  final String? createAt;
  List<FriendThumbModel?>? friendsThumbs;
  final String? fullname;
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


  String location(){
    if((state?.isNotEmpty ?? false) && (country?.isNotEmpty ?? false)){
      return '$state - $country';
    }else  if((state?.isNotEmpty ?? false)){
      return state!;
    }else if((country?.isNotEmpty ?? false)){
      return country!;
    }
    return '';

  }

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);

  Map<String, dynamic> toJson() => _$FriendModelToJson(this);
}


