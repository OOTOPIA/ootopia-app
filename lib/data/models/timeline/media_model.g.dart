// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      mediaUrl: json['mediaUrl'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'mediaUrl': instance.mediaUrl,
      'thumbUrl': instance.thumbUrl,
      'type': instance.type,
    };
