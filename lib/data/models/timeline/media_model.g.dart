// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) {
  return Media(
    mediaUrl: json['mediaUrl'] as String?,
    thumbnailUrl: json['thumbnailUrl'] as String?,
    type: json['type'] as String?,
  );
}

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': instance.type,
    };
