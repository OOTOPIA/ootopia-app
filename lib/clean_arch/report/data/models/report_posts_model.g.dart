// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_posts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportPostsModel _$ReportPostsModelFromJson(Map<String, dynamic> json) {
  return ReportPostsModel(
    visualizerPostUser: json['visualizerPostUser'] as bool,
    denouncedId: json['denouncedId'] as String,
    postId: json['postId'] as String?,
    reason: json['reason'] as String,
  );
}

Map<String, dynamic> _$ReportPostsModelToJson(ReportPostsModel instance) =>
    <String, dynamic>{
      'visualizerPostUser': instance.visualizerPostUser,
      'denouncedId': instance.denouncedId,
      'postId': instance.postId,
      'reason': instance.reason,
    };
