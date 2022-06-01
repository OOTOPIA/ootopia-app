// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interest_tags_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InterestTagsModel _$InterestTagsModelFromJson(Map<String, dynamic> json) {
  return InterestTagsModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    active: json['active'] as bool,
    tagOrder: json['tagOrder'] as int,
    language: json['language'] as String,
    createdAt: json['createdAt'] as String,
    updatedAt: json['updatedAt'] as String,
  )..selectedTag = json['selectedTag'] as bool?;
}
