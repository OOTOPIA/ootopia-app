import 'package:equatable/equatable.dart';

class TimelinePost extends Equatable {
  String id;
  String userId;
  String description;
  String type;
  String imageUrl;
  String videoUrl;
  String thumbnailUrl;
  String photoUrl;
  String username;
  int likesCount;
  int commentsCount;
  bool liked = false;
  DateTime createdAt;
  DateTime updatedAt;

  TimelinePost({
    this.id,
    this.userId,
    this.description,
    this.type,
    this.imageUrl,
    this.videoUrl,
    this.thumbnailUrl,
    this.photoUrl,
    this.username,
    this.likesCount,
    this.commentsCount,
    this.liked,
    this.createdAt,
    this.updatedAt,
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
        createdAt: parsedJson['createdAt'],
        updatedAt: parsedJson['updatedAt']);
  }

  @override
  List<Object> get props => [
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
        createdAt,
        updatedAt,
      ];
}
