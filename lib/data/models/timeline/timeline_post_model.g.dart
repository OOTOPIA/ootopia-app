// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelinePost _$TimelinePostFromJson(Map<String, dynamic> json) {
  return TimelinePost(
    id: json['id'] as String,
    userId: json['userId'] as String,
    description: json['description'] as String,
    type: json['type'] as String,
    imageUrl: json['imageUrl'] as String?,
    videoUrl: json['videoUrl'] as String?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    photoUrl: json['photoUrl'] as String?,
    username: json['username'] as String,
    likesCount: json['likesCount'] as int,
    commentsCount: json['commentsCount'] as int,
    oozTotalCollected: json['oozTotalCollected'] as String,
    liked: json['liked'] as bool,
    tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    oozToTransfer: (json['oozToTransfer'] as num?)?.toDouble(),
    oozRewarded: (json['oozRewarded'] as num?)?.toDouble(),
    city: json['city'] as String?,
    state: json['state'] as String?,
    country: json['country'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    badges: (json['badges'] as List<dynamic>?)
        ?.map((e) => Badge.fromJson(e as Map<String, dynamic>))
        .toList(),
    medias: (json['medias'] as List<dynamic>?)
        ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
        .toList(),
    usersTagged: (json['usersTagged'] as List<dynamic>?)
        ?.map((e) => UserSearchModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TimelinePostToJson(TimelinePost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'description': instance.description,
      'type': instance.type,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'photoUrl': instance.photoUrl,
      'username': instance.username,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
      'oozToTransfer': instance.oozToTransfer,
      'oozTotalCollected': instance.oozTotalCollected,
      'oozRewarded': instance.oozRewarded,
      'liked': instance.liked,
      'tags': instance.tags,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'badges': instance.badges,
      'medias': instance.medias,
      'usersTagged': instance.usersTagged,
    };
