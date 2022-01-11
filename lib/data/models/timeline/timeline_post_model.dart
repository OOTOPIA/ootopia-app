import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import './../users/badges_model.dart';

part "timeline_post_model.g.dart";

@JsonSerializable()
class TimelinePost {
  String id;
  String userId;
  String description;
  String type;
  String? imageUrl;
  String? videoUrl;
  String thumbnailUrl;
  String? photoUrl;
  String username;
  int likesCount;
  int commentsCount;
  double? oozToTransfer;
  double oozTotalCollected;
  double? oozRewarded;
  bool liked = false;
  List<String> tags;
  String? city;
  String? state;
  String? country;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Badge>? badges;

  TimelinePost({
    required this.id,
    required this.userId,
    required this.description,
    required this.type,
    this.imageUrl,
    this.videoUrl,
    required this.thumbnailUrl,
    this.photoUrl,
    required this.username,
    required this.likesCount,
    required this.commentsCount,
    required this.oozTotalCollected,
    required this.liked,
    required this.tags,
    this.oozToTransfer,
    this.oozRewarded,
    this.city,
    this.state,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.badges,
  });

  factory TimelinePost.fromJson(Map<String, dynamic> json) =>
      _$TimelinePostFromJson(json);

  Map<String, dynamic> toJson() => _$TimelinePostToJson(this);
}
