import 'package:json_annotation/json_annotation.dart';
import 'package:ootopia_app/data/models/users/user_comment.dart';
part 'comment_reply_model.g.dart';

@JsonSerializable()
class CommentReply {
  final String id;
  final String commentId;
  final String text;
  final List<String>? taggedUserIds;
  final String commentUserId;
  final String? photoCommentUser;
  final String replyToUserId;
  final String fullNameCommentUser;
  final List<UserSearchModel>? userComments;

  CommentReply({
    required this.id,
    required this.commentId,
    required this.text,
    this.taggedUserIds,
    required this.commentUserId,
    required this.photoCommentUser,
    required this.replyToUserId,
    required this.fullNameCommentUser,
    this.userComments,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) =>
      _$CommentReplyFromJson(json);
  Map<String, dynamic> toJson() => _$CommentReplyToJson(this);
}
