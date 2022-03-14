import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/comment_replies/comment_reply_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/comment_replies_store.dart';
import 'package:ootopia_app/shared/link_rich_text.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ItemReply extends StatefulWidget {
  final Comment comment;
  final CommentReply commentReplies;
  final bool lastWidget;
  final bool visibleDelete;
  final CommentRepliesStore? commentRepliesStore;
  final Function() getData;
  final Function replyComment;

  const ItemReply({
    Key? key,
    required this.comment,
    required this.commentReplies,
    required this.lastWidget,
    required this.visibleDelete,
    this.commentRepliesStore,
    required this.getData,
    required this.replyComment,
  }) : super(key: key);

  @override
  State<ItemReply> createState() => ItemReplyState();
}

class ItemReplyState extends State<ItemReply> {
  late AuthStore authStore;

  replyComment(CommentReply commentReply) {
    Comment comment = Comment(
      id: widget.comment.id,
      postId: widget.comment.postId,
      text: commentReply.text,
      userId: authStore.currentUser!.id!,
      username: authStore.currentUser!.fullname,
      photoUrl: authStore.currentUser!.photoUrl,
      totalReplies: widget.comment.totalReplies,
      userComments: commentReply.userComments,
    );
    widget.replyComment(comment);
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.commentReplies.photoCommentUser == null
                ? CircleAvatar(
                    radius: 19,
                    backgroundImage: AssetImage('assets/icons/user.png'),
                  )
                : CircleAvatar(
                    radius: 19,
                    backgroundImage:
                        NetworkImage(widget.commentReplies.photoCommentUser!),
                  ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.commentReplies.fullNameCommentUser,
                    style: TextStyle(
                      color: LightColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.43,
                        child: LinkRichText(
                          widget.commentReplies.text,
                          userCommentsList: widget.commentReplies.userComments,
                          maxLines: 10,
                        ),
                      ),
                      Visibility(
                        visible: widget.visibleDelete,
                        child: GestureDetector(
                          onTap: () {
                            deleteComment(widget.commentReplies, context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.delete,
                            style: TextStyle(
                              color: LightColors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Text(
                        "Responder",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    onTap: () {
                      replyComment(widget.commentReplies);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        if (widget.lastWidget)
          SizedBox(
            height: 25,
          )
      ],
    );
  }

  void deleteComment(CommentReply commentReply, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              AppLocalizations.of(context)!.commentsWillBePermanentlyRemoved,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pop();
                  await widget.commentRepliesStore!
                      .deleteComments(commentReply.id);
                  widget.commentRepliesStore!.listComments.clear();
                  widget.commentRepliesStore!.currentPageComment = 1;
                  widget.getData();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
