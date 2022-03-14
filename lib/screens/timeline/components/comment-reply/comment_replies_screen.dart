import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/comment_replies_store.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/component/item_reply.dart';
import 'package:provider/provider.dart';

class CommentReplies extends StatefulWidget {
  final Comment comment;
  final Function updateState;

  CommentReplies({required this.comment, required this.updateState});

  @override
  State<CommentReplies> createState() => CcommentStateReplies();
}

class CcommentStateReplies extends State<CommentReplies> {
  CommentRepliesStore commentReplies = CommentRepliesStore();
  bool showCommentReplies = false;

  FocusNode focusNode = FocusNode();
  late AuthStore authStore;

  Future<void> _getData() async {
    setState(() {
      commentReplies.isLoading = true;
      widget.updateState();
    });

    await commentReplies.getCommentReplies(
        widget.comment.id, commentReplies.currentPageComment);

    commentReplies.currentPageComment++;

    setState(() {
      commentReplies.isLoading = false;
      widget.updateState();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  replyComment() {
    print("ASDFGHJKL");
    widget.updateState();
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);

    return Observer(builder: (context) {
      return Column(children: [
        if (widget.comment.totalReplies != null &&
            widget.comment.totalReplies! > 0 &&
            ((widget.comment.totalReplies! -
                    commentReplies.listComments.length) >
                0))
          GestureDetector(
            child: Text(
              "Carregar ${widget.comment.totalReplies! - commentReplies.listComments.length} Respostas",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onTap: () {
              _getData();
            },
          ),
        LoadingOverlay(
          isLoading: commentReplies.isLoading,
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.61,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  itemCount: commentReplies.listComments.length,
                  itemBuilder: (context, index) {
                    var commentReply = commentReplies.listComments[index];
                    bool visibleDelete;
                    if (authStore.currentUser == null) {
                      visibleDelete = false;
                    } else {
                      visibleDelete = authStore.currentUser!.id! ==
                          commentReply.commentUserId;
                    }
                    return ItemReply(
                      commentReplies: commentReply,
                      lastWidget:
                          commentReplies.listComments.length - 1 != index,
                      visibleDelete: visibleDelete,
                      commentRepliesStore: commentReplies,
                      getData: _getData,
                      replyComment: replyComment,
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ]);
    });
  }
}
