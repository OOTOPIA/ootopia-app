import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/comment_replies_screen.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
import 'package:ootopia_app/shared/link_rich_text.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItemComment extends StatefulWidget {
  final Comment comment;
  final bool visibleDelete;
  final CommentStore commentStore;
  final String postId;
  final Function() getData;
  final Function replyComment;
  final Function updateState;

  ItemComment({
    Key? key,
    required this.comment,
    required this.visibleDelete,
    required this.commentStore,
    required this.postId,
    required this.getData,
    required this.replyComment,
    required this.updateState,
  }) : super(key: key);

  @override
  State<ItemComment> createState() => _ItemCommentState();
}

class _ItemCommentState extends State<ItemComment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.comment.photoUrl == null
                ? CircleAvatar(
                    radius: 19,
                    backgroundImage: AssetImage('assets/icons/user.png'),
                  )
                : CircleAvatar(
                    radius: 19,
                    backgroundImage: NetworkImage(widget.comment.photoUrl!),
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
                    widget.comment.username!,
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
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: LinkRichText(
                          widget.comment.text,
                          userCommentsList: widget.comment.userComments,
                          maxLines: 10,
                        ),
                      ),
                      Visibility(
                        visible: widget.visibleDelete,
                        child: GestureDetector(
                          onTap: () {
                            deleteComment(widget.comment, context);
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
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        AppLocalizations.of(context)!.reply,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    onTap: () {
                      widget.replyComment(widget.comment);
                    },
                  ),
                  CommentReplies(
                    comment: widget.comment,
                    updateState: widget.updateState,
                    replyComment: widget.replyComment,
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  void deleteComment(Comment comment, BuildContext context) {
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
                  await widget.commentStore
                      .deleteComments(widget.postId, comment.id);
                  widget.commentStore.listComments.clear();
                  widget.commentStore.currentPageComment = 1;
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
