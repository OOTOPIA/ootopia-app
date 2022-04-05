import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/users/user_search_model.dart';
import 'package:ootopia_app/data/models/comment_replies/comment_reply_model.dart';
import 'package:ootopia_app/data/models/comments/comment_post_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/timeline/components/comment-reply/comment_replies_store.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
import 'package:ootopia_app/screens/timeline/components/comments/component/item_comment.dart';
import 'package:ootopia_app/screens/timeline/components/comments/component/list_of_users.dart';
import 'package:ootopia_app/screens/timeline/components/comments/component/text_field.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/rich_text_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CommentScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  CommentScreen(this.args);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> with SecureStoreMixin {
  late RichTextController _inputController;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  CommentStore commentStore = CommentStore();
  CommentRepliesStore commentRepliesStore = CommentRepliesStore();
  late HomeStore homeStore;
  late AuthStore authStore;
  int postCommentsCount = 0;
  String postId = '';
  String? commentReply;
  int? indexComment;
  String? replyToUserId;
  bool isIconBlue = false;
  FocusNode focusNode = FocusNode();
  bool seSelectedUser = false;
  Timer? _debounce;
  final ScrollController scrollController = ScrollController();
  String? userNameReply;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () => commentStore.updateOnScroll(scrollController),
    );
    _inputController = RichTextController(
      deleteOnBack: false,
      patternMatchMap: {
        RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w/\-?=%.][-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?"):
            const TextStyle(
          color: LightColors.linkText,
        ),
      },
      onMatch: (List<String> matches) {},
    );

    postId = widget.args['post'].id;
    Future.delayed(Duration.zero, () async {
      commentStore.isLoading = true;
      homeStore.setResizeToAvoidBottomInset(true);
      homeStore.setSeeCrip(false);

      await commentStore.getComments(postId, commentStore.currentPageComment);
      commentStore.isLoading = false;
    });
    postCommentsCount = widget.args['post'].commentsCount;
    this.trackingEvents.timelineViewedComments({
      "postOwnerId": widget.args['post'].userId,
      "commentsCount": widget.args['post'].commentsCount,
    });

    focusNode.addListener(() {
      setState(() {
        print(focusNode.hasFocus);
      });
    });
  }

  void addUserInText(UserSearchModel e) {
    var text = _inputController.text;

    var name = '‌@${e.fullname}‌ ';

    var countAtEndName = 0, nameStartRange = 0;
    for (var i = text.length - 1; i >= 0; i--) {
      if (text[i].contains('@')) {
        _inputController.text =
            text.replaceRange(i, i + countAtEndName + 1, name);
        nameStartRange = i;
        break;
      }
      countAtEndName++;
    }

    e.start = nameStartRange;
    e.end = nameStartRange + e.fullname.length + 3;
    if (commentStore.excludedIds!.isEmpty) {
      commentStore.excludedIds = commentStore.excludedIds! + '${e.id}';
    } else {
      commentStore.excludedIds = commentStore.excludedIds! + ',${e.id}';
    }
    commentStore.listTaggedUsers?.add(e);
    _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length));
    setState(() {
      seSelectedUser = false;
    });
  }

  Widget suffixIcon() {
    return Observer(builder: (context) {
      if (commentStore.isLoading) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        );
      } else {
        return GestureDetector(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: isIconBlue
                ? Image.asset(
                    'assets/icons/icon-send-blue.png',
                    height: 22,
                    width: 22,
                  )
                : Image.asset(
                    'assets/icons/icon-send-grey.png',
                    height: 22,
                    width: 22,
                  ),
          ),
          onTap: onTap,
        );
      }
    });
  }

  clearInpuntTextAndRemoveUsers() {
    commentStore.excludedIds = '';
    commentStore.fullName = '';
    commentStore.listAllUsers.clear();
    seSelectedUser = false;
    _inputController.clear();
    userNameReply = null;
    replyToUserId = null;
    commentStore.listTaggedUsers?.clear();
    commentReply = null;
    indexComment = null;
  }

  void onChanged(String value) async {
    value = value.trim();

    if (value.length > 0) {
      setState(() {
        isIconBlue = true;
      });
      var endName = 0;
      for (var item in commentStore.listTaggedUsers!) {
        var startname = value.indexOf('@${item.fullname}', endName);

        if (startname < 0) {
          if (commentStore.excludedIds!.contains(',${item.id}')) {
            commentStore.excludedIds =
                commentStore.excludedIds?.replaceAll(',${item.id}', '');
          } else {
            if (commentStore.excludedIds!.contains('${item.id},')) {
              commentStore.excludedIds =
                  commentStore.excludedIds?.replaceAll('${item.id},', '');
            } else {
              commentStore.excludedIds =
                  commentStore.excludedIds?.replaceAll('${item.id}', '');
            }
          }
          commentStore.listTaggedUsers?.remove(item);
          break;
        }
        endName = startname + item.fullname.length + 3;
      }
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(Duration(seconds: 1, milliseconds: 700), () async {
        var getLastString = value.split("‌@");
        if (getLastString.last.contains('@')) {
          setState(() {
            seSelectedUser = true;
          });
          var startName = getLastString.last.split('@').last;
          var finishName = startName.split(RegExp("‌"));
          commentStore.currentPageUser = 1;
          commentStore.fullName = finishName.first;
          await commentStore.searchUser();
        } else {
          setState(() {
            seSelectedUser = false;
          });
        }
      });
    } else {
      commentStore.listTaggedUsers?.clear();
      commentStore.excludedIds = '';
      commentStore.fullName = '';
      setState(() {
        seSelectedUser = false;
        isIconBlue = false;
      });
    }
  }

  void onTap() async {
    if (isIconBlue) {
      try {
        if (_inputController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.writeYourComment)));
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          commentStore.isLoading = true;

          if (commentReply != null) {
            CommentReply createCommentReply =
                await commentRepliesStore.createComment(
                    commentReply!,
                    _inputController.text.trim(),
                    replyToUserId!,
                    commentStore.listTaggedUsers);
            isIconBlue = false;
            commentStore.listComments[indexComment!].totalReplies =
                commentStore.listComments[indexComment!].totalReplies != null
                    ? commentStore.listComments[indexComment!].totalReplies! + 1
                    : 1;
            if (commentStore.listComments[indexComment!].commentReplies !=
                null) {
              commentStore.listComments[indexComment!].commentReplies!
                  .add(createCommentReply);
            } else {
              commentStore.listComments[indexComment!].commentReplies = [
                createCommentReply
              ];
            }
            clearInpuntTextAndRemoveUsers();
            commentStore.isLoading = false;
            setState(() {});
          } else {
            await commentStore.createComment(
                postId, _inputController.text.trim());
            isIconBlue = false;
            clearInpuntTextAndRemoveUsers();
            commentStore.currentPageComment = 1;
            _getData();
            commentStore.isLoading = false;
          }
        }
      } catch (e) {
        print(e);
        showModalBottomSheet(
          context: context,
          barrierColor: Colors.black.withAlpha(1),
          backgroundColor: Colors.black.withAlpha(1),
          builder: (BuildContext context) {
            return SnackBarWidget(
              menu: AppLocalizations.of(context)!.couldNotSend,
              text: AppLocalizations.of(context)!.tryAgain,
              automaticClosing: true,
            );
          },
        );
        commentStore.isLoading = false;
      }
    }
  }

  Future<void> _getData() async {
    await commentStore.getComments(postId, commentStore.currentPageComment);
    commentStore.isLoading = false;
  }

  replyComment(Comment comment) {
    userNameReply = comment.username;
    _inputController.text = "@";
    addUserInText(
      UserSearchModel(fullname: comment.username!, id: comment.userId),
    );
    replyToUserId = comment.userId;
    commentReply = comment.id;
    indexComment = commentStore.listComments
        .indexWhere((_comment) => _comment.id == comment.id);
    setState(() {});
  }

  @override
  void dispose() {
    Future.delayed(Duration(milliseconds: 300), () async {
      _debounce?.cancel();
      homeStore.setSeeCrip(true);
      homeStore.setResizeToAvoidBottomInset(false);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    homeStore = Provider.of<HomeStore>(context);
    authStore = Provider.of<AuthStore>(context);

    return Observer(builder: (context) {
      return LoadingOverlay(
        isLoading: commentStore.isLoading,
        child: GestureDetector(
          onTap: () {
            setState(() {
              seSelectedUser = false;
            });
            focusNode.unfocus();
          },
          child: Scaffold(
            body: Stack(
              children: [
                BackgroundButterflyTop(positioned: -59),
                Visibility(
                    visible: !focusNode.hasFocus,
                    child: BackgroundButterflyBottom(positioned: -50)),
                RefreshIndicator(
                  onRefresh: () async {
                    commentStore.isLoading = true;
                    commentStore.listComments.clear();
                    commentStore.currentPageComment = 1;
                    await _getData();
                    commentStore.isLoading = false;
                  },
                  child: Column(
                    children: [
                      Container(
                        color: LightColors.grey.withOpacity(0.05),
                        alignment: Alignment.centerLeft,
                        height: 56,
                        padding: EdgeInsets.only(left: 24),
                        child: Text(
                          AppLocalizations.of(context)!.comments,
                          style: TextStyle(
                            color: Color(0xff003694),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      commentStore.listComments.isEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.55,
                              alignment: Alignment.center,
                              child: Text(
                                AppLocalizations.of(context)!.noComment,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.61,
                              child: NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  //FocusScope.of(context).requestFocus(newFocusNode());
                                  if (scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent &&
                                      commentStore.hasMoreComments &&
                                      !commentStore.isLoading) {
                                    commentStore.currentPageComment++;
                                    commentStore.isLoading = true;

                                    _getData();
                                    commentStore.isLoading = false;

                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: Column(
                                      children: commentStore.listComments
                                          .map((comment) {
                                        bool visibleDelete;
                                        if (authStore.currentUser == null) {
                                          visibleDelete = false;
                                        } else {
                                          visibleDelete =
                                              authStore.currentUser!.id! ==
                                                  comment.userId;
                                        }
                                        return ItemComment(
                                          comment: comment,
                                          visibleDelete: visibleDelete,
                                          commentStore: commentStore,
                                          getData: _getData,
                                          postId: postId,
                                          replyComment: replyComment,
                                          updateState: () {
                                            setState(() {});
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 24, left: 24, right: 24, top: 24),
                    child: TextFieldComment(
                      authStore: authStore,
                      commentStore: commentStore,
                      userNameReply: userNameReply,
                      removeReply: () {
                        clearInpuntTextAndRemoveUsers();
                        setState(() {});
                      },
                      focusNode: focusNode,
                      inputController: _inputController,
                      onChange: onChanged,
                      onTap: onTap,
                      suffixIcon: suffixIcon(),
                    ),
                  ),
                ),
                if (seSelectedUser)
                  ListOfUsers(
                    commentStore: commentStore,
                    inputController: _inputController,
                    scrollController: scrollController,
                    addUserInText: addUserInText,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
