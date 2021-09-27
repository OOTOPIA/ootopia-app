// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChaptersModel _$ChaptersModelFromJson(Map<String, dynamic> json) {
  return ChaptersModel(
    id: json['id'] as int,
    title: json['title'] as String,
    videoUrl: json['videoUrl'] as String,
    videoThumbUrl: json['videoThumbUrl'] as String,
    ooz: (json['ooz'] as num).toDouble(),
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  );
}

Map<String, dynamic> _$ChaptersModelToJson(ChaptersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'videoUrl': instance.videoUrl,
      'videoThumbUrl': instance.videoThumbUrl,
      'ooz': instance.ooz,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
