// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChaptersModel _$ChaptersModelFromJson(Map<String, dynamic> json) =>
    ChaptersModel(
      id: json['id'] as int,
      title: json['title'] as String,
      videoUrl: json['videoUrl'] as String,
      videoThumbUrl: json['videoThumbUrl'] as String,
      ooz: (json['ooz'] as num).toDouble(),
      time: json['time'] as String,
      completed: json['completed'] as bool,
    );

Map<String, dynamic> _$ChaptersModelToJson(ChaptersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'videoUrl': instance.videoUrl,
      'videoThumbUrl': instance.videoThumbUrl,
      'ooz': instance.ooz,
      'time': instance.time,
      'completed': instance.completed,
    };
