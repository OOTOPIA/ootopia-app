// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_reply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentReply _$CommentReplyFromJson(Map<String, dynamic> json) {
  return CommentReply(
    id: json['id'] as String,
    commentId: json['commentId'] as String,
    text: json['text'] as String,
    taggedUserIds: (json['taggedUserIds'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    commentUserId: json['commentUserId'] as String,
    photoCommentUser: json['photoCommentUser'] as String?,
    replyToUserId: json['replyToUserId'] as String,
    fullNameCommentUser: json['fullNameCommentUser'] as String,
    usersComments: (json['usersComments'] as List<dynamic>?)
        ?.map((e) => UserSearchModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CommentReplyToJson(CommentReply instance) =>
    <String, dynamic>{
      'id': instance.id,
      'commentId': instance.commentId,
      'text': instance.text,
      'taggedUserIds': instance.taggedUserIds,
      'commentUserId': instance.commentUserId,
      'photoCommentUser': instance.photoCommentUser,
      'replyToUserId': instance.replyToUserId,
      'fullNameCommentUser': instance.fullNameCommentUser,
      'usersComments': instance.usersComments,
    };
