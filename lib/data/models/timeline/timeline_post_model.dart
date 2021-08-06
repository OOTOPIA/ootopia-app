import 'package:equatable/equatable.dart';
import './../users/badges_model.dart';

class TimelinePost extends Equatable {
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
  double oozToTransfer = 0;
  double oozTotalCollected = 0;
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
    this.city,
    this.state,
    this.country,
    this.createdAt,
    this.updatedAt,
    this.badges
  });

  factory TimelinePost.fromJson(Map<String, dynamic> parsedJson) {
    return TimelinePost(
      id: parsedJson['id'],
      userId: parsedJson['userId'],
      description: parsedJson['description'],
      type: parsedJson['type'],
      imageUrl: parsedJson['imageUrl'],
      videoUrl: parsedJson['videoUrl'],
      thumbnailUrl: parsedJson['thumbnailUrl'],
      photoUrl: parsedJson['photoUrl'],
      username: parsedJson['username'],
      likesCount: parsedJson['likesCount'],
      liked: (parsedJson['liked'] == null ? false : parsedJson['liked']),
      commentsCount: parsedJson['commentsCount'],
      oozTotalCollected: (parsedJson['oozTotalCollected'] == null
          ? 0
          : double.parse(parsedJson['oozTotalCollected'])),
      tags: List.from(parsedJson['tags']),
      city: parsedJson['city'],
      state: parsedJson['state'],
      country: parsedJson['country'],
      createdAt: parsedJson['createdAt'],
      updatedAt: parsedJson['updatedAt'],
      badges: (
        parsedJson['badges'] == null ?
          []
          : (
            parsedJson['badges'] as List<dynamic>
          ).map((e) => Badge.fromJson(e as Map<String, dynamic>))
            .toList()
      )
    );
  }

  @override
  List<dynamic> get props => [
        id,
        userId,
        description,
        type,
        imageUrl,
        videoUrl,
        thumbnailUrl,
        photoUrl,
        username,
        likesCount,
        commentsCount,
        liked,
        tags,
        city,
        state,
        country,
        createdAt,
        updatedAt,
        badges
      ];
}
