import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/data/models/timeline/media_model.dart';
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
  String oozTotalCollected;
  double? oozRewarded;
  bool liked = false;
  List<String> tags;
  String? city;
  String? state;
  String? country;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Badge>? badges;
  List<Media>? medias;

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
    this.medias
  });

  factory TimelinePost.fromJson(Map<String, dynamic> json) =>
      _$TimelinePostFromJson(json);

  Map<String, dynamic> toJson() => _$TimelinePostToJson(this);
}
