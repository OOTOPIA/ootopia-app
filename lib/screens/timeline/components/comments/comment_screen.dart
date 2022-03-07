import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/link_rich_text.dart';
import 'package:ootopia_app/shared/rich_text_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  late HomeStore homeStore;
  late AuthStore authStore;
  int postCommentsCount = 0;
  String postId = '';
  bool isIconBlue = false;
  FocusNode focusNode = FocusNode();
  bool seSelectedUser = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () =>
          commentStore.updateOnScroll(scrollController, _inputController.text),
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

  Future<void> _getData() async {
    await commentStore.getComments(postId, commentStore.currentPageComment);
    commentStore.isLoading = false;
  }

  @override
  void dispose() {
    Future.delayed(Duration(milliseconds: 300), () async {
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
          onTap: () => focusNode.unfocus(),
          child: Scaffold(
            body: Stack(
              children: [
                BackgroundButterflyTop(positioned: -59),
                Visibility(
                    visible: !focusNode.hasFocus,
                    child: BackgroundButterflyBottom(positioned: -50)),
                SingleChildScrollView(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.85),
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
                                      scrollInfo.metrics.maxScrollExtent) {
                                    commentStore.currentPageComment++;
                                    commentStore.isLoading = true;

                                    _getData();
                                    commentStore.isLoading = false;

                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    commentStore.isLoading = true;
                                    commentStore.listComments.clear();
                                    commentStore.currentPageComment = 1;
                                    await _getData();
                                    commentStore.isLoading = false;
                                  },
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    itemCount: commentStore.listComments.length,
                                    itemBuilder: (context, index) {
                                      var comment =
                                          commentStore.listComments[index];
                                      bool visibleDelete;
                                      if (authStore.currentUser == null) {
                                        visibleDelete = false;
                                      } else {
                                        visibleDelete =
                                            authStore.currentUser!.id! ==
                                                commentStore
                                                    .listComments[index].userId;
                                      }
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              comment.photoUrl == 'null' ||
                                                      comment.photoUrl == null
                                                  ? CircleAvatar(
                                                      radius: 19,
                                                      backgroundImage: AssetImage(
                                                          'assets/icons/user.png'),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 19,
                                                      backgroundImage:
                                                          NetworkImage(comment
                                                              .photoUrl!),
                                                    ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      comment.username!,
                                                      style: TextStyle(
                                                        color:
                                                            LightColors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                          child: LinkRichText(
                                                            comment.text,
                                                            userCommentsList:
                                                                comment
                                                                    .userComments,
                                                            maxLines: 10,
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              visibleDelete,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          Text(
                                                                        AppLocalizations.of(context)!
                                                                            .commentsWillBePermanentlyRemoved,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            AppLocalizations.of(context)!.cancel,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            FocusManager.instance.primaryFocus?.unfocus();
                                                                            Navigator.of(context).pop();
                                                                            await commentStore.deleteComments(postId,
                                                                                comment.id);
                                                                            commentStore.listComments.clear();
                                                                            commentStore.currentPageComment =
                                                                                1;
                                                                            _getData();
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            'OK',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            child: Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .delete,
                                                              style: TextStyle(
                                                                color:
                                                                    LightColors
                                                                        .grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 25,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: 24, left: 24, right: 24, top: 24),
                    child: TextField(
                      autocorrect: true,
                      enableSuggestions: true,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: commentStore.isLoading ? 1 : null,
                      minLines: 1,
                      focusNode: focusNode,
                      onTap: authStore.currentUser == null
                          ? () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              Navigator.of(context).pushNamed(
                                PageRoute.Page.loginScreen.route,
                                arguments: {
                                  "returnToPageWithArgs": {
                                    "currentPageName": "wallet",
                                    "arguments": null
                                  }
                                },
                              );
                            }
                          : null,
                      onChanged: (value) {
                        value = value.trim();

                        if (value.length > 0) {
                          var getLastString = value.split(RegExp("ㅤ@"));
                          if (getLastString.last.contains('@')) {
                            setState(() {
                              seSelectedUser = true;
                            });
                            var startName = getLastString.last.split('@').last;
                            var finishName = startName.split(RegExp("ㅤ"));
                            Future.delayed(Duration(milliseconds: 500), () {
                              commentStore.searchUser(finishName.first);
                            });
                          } else {
                            setState(() {
                              seSelectedUser = false;
                              isIconBlue = true;
                            });
                          }
                        } else {
                          commentStore.listUsersMarket!.clear();
                          setState(() {
                            seSelectedUser = false;
                            isIconBlue = false;
                          });
                        }
                      },
                      style: TextStyle(color: LightColors.grey),
                      controller: _inputController,
                      decoration: InputDecoration(
                        fillColor: Colors.white
                            .withOpacity(!focusNode.hasFocus ? 0.3 : 1.0),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: LightColors.grey, width: 0.25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: LightColors.grey, width: 0.25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: LightColors.grey, width: 0.25),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        contentPadding: EdgeInsets.all(16),
                        hintText:
                            AppLocalizations.of(context)!.writeYourComment,
                        hintStyle: TextStyle(color: LightColors.grey),
                        suffixIcon: Observer(builder: (context) {
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
                              onTap: () async {
                                if (isIconBlue) {
                                  if (_inputController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)!
                                                    .writeYourComment)));
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    commentStore.isLoading = true;
                                    commentStore.currentPageComment = 1;
                                    isIconBlue = false;
                                    await commentStore.createComment(
                                        postId, _inputController.text.trim());
                                    _inputController.clear();
                                    commentStore.listComments.clear();
                                    _getData();
                                    commentStore.isLoading = false;
                                  }
                                }
                              },
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ),
                if (seSelectedUser) listOfUsers(context),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget listOfUsers(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * .30,
        padding: EdgeInsets.only(left: 16, top: 16),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Observer(builder: (context) {
            if (commentStore.viewState == ViewState.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: commentStore.listAllUsers
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: InkWell(
                            onTap: () {
                              commentStore.listUsersMarket?.add(e.id);
                              setState(() {
                                var list =
                                    _inputController.text.trim().split(' ');
                                print(list);
                                list.removeLast();
                                list.add('ㅤ@${e.fullname}ㅤ');
                                _inputController.clear();
                                for (var item in list) {
                                  if (item.contains('@')) {
                                    _inputController.text += '$item';
                                  } else {
                                    _inputController.text += ' $item';
                                  }
                                }

                                _inputController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                            _inputController.text.length - 1));
                                seSelectedUser = false;
                              });
                            },
                            child: Row(
                              children: [
                                if (e.photoUrl != null)
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(e.photoUrl!),
                                  )
                                else
                                  CircleAvatar(
                                    radius: 25,
                                    child: Image.asset(
                                      'assets/icons/user.png',
                                    ),
                                  ),
                                SizedBox(width: 8),
                                Text(e.fullname),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (commentStore.viewState == ViewState.loadingNewData)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
