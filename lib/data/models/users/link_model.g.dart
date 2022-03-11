// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) {
  return Link(
    URL: json['URL'] as String,
    title: json['title'] as String,
  )..textToShow = json['textToShow'] as String?;
}

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'URL': instance.URL,
      'title': instance.title,
      'textToShow': instance.textToShow,
    };
