// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interests_tags_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestsTagsModel _$InterestsTagsModelFromJson(Map<String, dynamic> json) {
  return InterestsTagsModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    active: json['active'] as bool,
    tagOrder: json['tagOrder'] as int,
    language: json['language'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
    selectedTag: json['selectedTag'] as bool?,
  );
}

Map<String, dynamic> _$InterestsTagsModelToJson(InterestsTagsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'active': instance.active,
      'selectedTag': instance.selectedTag,
      'tagOrder': instance.tagOrder,
      'language': instance.language,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
