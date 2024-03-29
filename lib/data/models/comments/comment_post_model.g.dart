// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      text: json['text'] as String,
      photoUrl: json['photoUrl'] as String?,
      username: json['username'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      userComments: (json['usersComments'] as List<dynamic>?)
          ?.map((e) => UserSearchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalReplies: json['totalReplies'] as int?,
      commentReplies: (json['commentReplies'] as List<dynamic>?)
          ?.map((e) => CommentReply.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'postId': instance.postId,
      'userId': instance.userId,
      'text': instance.text,
      'photoUrl': instance.photoUrl,
      'username': instance.username,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'totalReplies': instance.totalReplies,
      'commentReplies': instance.commentReplies,
      'usersComments': instance.userComments,
    };
