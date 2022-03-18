import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/comment_replies/comment_reply_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/comment_replies_store.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/component/item_reply.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';

class CommentReplies extends StatefulWidget {
  final Comment comment;
  final Function updateState;
  final Function replyComment;

  CommentReplies({
    required this.comment,
    required this.updateState,
    required this.replyComment,
  });

  @override
  State<CommentReplies> createState() => CcommentStateReplies();
}

class CcommentStateReplies extends State<CommentReplies> {
  CommentRepliesStore commentRepliesStore = CommentRepliesStore();
  bool hiddenAnswers = false;

  FocusNode focusNode = FocusNode();
  late AuthStore authStore;

  Future<void> _getData() async {
    commentRepliesStore.isLoading = true;
    widget.updateState();

    try {
      await commentRepliesStore.getCommentReplies(
          widget.comment.id, commentRepliesStore.currentPageComment);

      commentRepliesStore.currentPageComment++;
    } catch (e) {
      showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.black.withAlpha(1),
        builder: (BuildContext context) {
          return SnackBarWidget(
            menu: AppLocalizations.of(context)!.couldNotLoad,
            text: AppLocalizations.of(context)!.tryAgain,
            automaticClosing: true,
          );
        },
      );
    }

    commentRepliesStore.isLoading = false;
    widget.updateState();
  }

  deleteCommentReply(CommentReply reply) async {
    if (await commentRepliesStore.deleteComments(reply.id)) {
      if (widget.comment.commentReplies != null) {
        int widgetIndex = widget.comment.commentReplies!
            .indexWhere((_reply) => _reply.id == reply.id);
        if (widgetIndex >= 0) {
          widget.comment.commentReplies!.removeAt(widgetIndex);
        }
      }
      if (commentRepliesStore.listComments != null) {
        int replyIndex = commentRepliesStore.listComments
            .indexWhere((_reply) => _reply.id == reply.id);
        if (replyIndex >= 0) {
          commentRepliesStore.listComments.removeAt(replyIndex);
        }
      }
      widget.updateState();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant CommentReplies oldWidget) {
    if (widget.comment.commentReplies != null) {
      widget.comment.commentReplies!.forEach((element) {
        if (commentRepliesStore.listComments != null &&
            !commentRepliesStore.listComments.contains(element)) {
          commentRepliesStore.listComments.add(element);
        } else if (commentRepliesStore.listComments == null) {
          commentRepliesStore.listComments.add(element);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);

    return Observer(builder: (context) {
      return Column(children: [
        if (widget.comment.totalReplies != null &&
            widget.comment.totalReplies! > 0 &&
            ((widget.comment.totalReplies! -
                        commentRepliesStore.listComments.length) !=
                    0 ||
                commentRepliesStore.hiddenAnswers))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    commentRepliesStore.isLoading
                        ? AppLocalizations.of(context)!.loading
                        : AppLocalizations.of(context)!.viewMoreReply.replaceFirst(
                            "%amount%",
                            (widget.comment.totalReplies! -
                                        commentRepliesStore
                                            .listComments.length) !=
                                    0
                                ? "${widget.comment.totalReplies! - commentRepliesStore.listComments.length}"
                                : "${widget.comment.totalReplies!}"),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    if ((widget.comment.totalReplies! -
                            commentRepliesStore.listComments.length) !=
                        0) {
                      _getData();
                    }
                    setState(() {
                      commentRepliesStore.hiddenAnswers = false;
                    });
                  },
                ),
              ],
            ),
          ),
        if (widget.comment.totalReplies != null &&
            widget.comment.totalReplies! > 5 &&
            !commentRepliesStore.hiddenAnswers &&
            ((widget.comment.totalReplies! -
                    commentRepliesStore.listComments.length) ==
                0))
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Text(
                    AppLocalizations.of(context)!.hideReplies,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      commentRepliesStore.hiddenAnswers = true;
                    });
                  },
                ),
              ],
            ),
          ),
        if (!commentRepliesStore.isLoading &&
            !commentRepliesStore.hiddenAnswers)
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 16),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  itemCount: commentRepliesStore.listComments.length,
                  itemBuilder: (context, index) {
                    var commentReply = commentRepliesStore.listComments[index];
                    bool visibleDelete;
                    if (authStore.currentUser == null) {
                      visibleDelete = false;
                    } else {
                      visibleDelete = authStore.currentUser!.id! ==
                          commentReply.commentUserId;
                    }
                    return ItemReply(
                      comment: widget.comment,
                      commentReplies: commentReply,
                      lastWidget:
                          commentRepliesStore.listComments.length - 1 != index,
                      visibleDelete: visibleDelete,
                      commentRepliesStore: commentRepliesStore,
                      getData: _getData,
                      replyComment: widget.replyComment,
                      deleteReply: deleteCommentReply,
                    );
                  },
                ),
              ),
            ],
          )
      ]);
    });
  }
}
