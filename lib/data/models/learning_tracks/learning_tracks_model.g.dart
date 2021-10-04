// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_tracks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningTracksModel _$LearningTracksModelFromJson(Map<String, dynamic> json) {
  return LearningTracksModel(
    id: json['id'] as String,
    userPhotoUrl: json['userPhotoUrl'] as String,
    userName: json['userName'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    chapters: (json['chapters'] as List<dynamic>)
        .map((e) => ChaptersModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    imageUrl: json['imageUrl'] as String,
    ooz: (json['ooz'] as num).toDouble(),
    time: json['time'] as String,
    location: json['location'] as String?,
    strapiId: json['strapiId'] as String,
    imageUpdatedAt: json['imageUpdatedAt'] as String,
  );
}

Map<String, dynamic> _$LearningTracksModelToJson(
        LearningTracksModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userPhotoUrl': instance.userPhotoUrl,
      'userName': instance.userName,
      'title': instance.title,
      'description': instance.description,
      'chapters': instance.chapters,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'time': instance.time,
      'imageUrl': instance.imageUrl,
      'ooz': instance.ooz,
      'location': instance.location,
      'strapiId': instance.strapiId,
      'imageUpdatedAt': instance.imageUpdatedAt,
    };
