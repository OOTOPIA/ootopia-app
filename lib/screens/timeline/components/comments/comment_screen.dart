import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
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
  TextEditingController _inputController = TextEditingController();
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  CommentStore commentStore = CommentStore();
  late HomeStore homeStore;
  late AuthStore authStore;
  int currentPage = 1;
  int postCommentsCount = 0;
  String postId = '';

  @override
  void initState() {
    super.initState();

    postId = widget.args['post'].id;
    Future.delayed(Duration.zero, () async {
      homeStore.setResizeToAvoidBottomInset(true);
      homeStore.setSeeCrip(false);

      await commentStore.getComments(postId, currentPage);
    });
    postCommentsCount = widget.args['post'].commentsCount;
    this.trackingEvents.timelineViewedComments({
      "postOwnerId": widget.args['post'].userId,
      "commentsCount": widget.args['post'].commentsCount,
    });
  }

  Future<void> _getData() async {
    print(currentPage);
    await commentStore.getComments(postId, currentPage);
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
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            body: SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85),
              child: Column(
                children: [
                  Expanded(
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
                                height:
                                    MediaQuery.of(context).size.height * 0.55,
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!.noComment,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.61,
                                child: NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification scrollInfo) {
                                    if (scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent) {
                                      currentPage++;
                                      _getData();
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  },
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      commentStore.listComments.clear();
                                      currentPage = 1;
                                      await _getData();
                                    },
                                    child: ListView.builder(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 24),
                                      shrinkWrap: true,
                                      itemCount:
                                          commentStore.listComments.length,
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
                                                      .listComments[index]
                                                      .userId;
                                        }
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    comment.photoUrl ==
                                                                'null' ||
                                                            comment.photoUrl ==
                                                                null
                                                        ? CircleAvatar(
                                                            radius: 19,
                                                            backgroundImage:
                                                                AssetImage(
                                                                    'assets/icons/user.png'),
                                                          )
                                                        : CircleAvatar(
                                                            radius: 19,
                                                            backgroundImage:
                                                                NetworkImage(comment
                                                                    .photoUrl!),
                                                          ),
                                                    SizedBox(width: 8),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          comment.username!,
                                                          style: TextStyle(
                                                            color: LightColors
                                                                .black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          comment.text
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: LightColors
                                                                .black,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: visibleDelete,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .commentsWillBePermanentlyRemoved,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .cancel,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    await commentStore.deleteComments(
                                                                        postId,
                                                                        comment
                                                                            .id);
                                                                    commentStore
                                                                        .listComments
                                                                        .clear();
                                                                    currentPage =
                                                                        1;
                                                                    await commentStore
                                                                        .getComments(
                                                                            postId,
                                                                            currentPage);
                                                                  },
                                                                  child: Text(
                                                                    'OK',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
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
                                                        color: LightColors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 24,
                      left: 24,
                      right: 24,
                    ),
                    child: TextField(
                      focusNode:
                          authStore.currentUser == null ? FocusNode() : null,
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
                      style: TextStyle(color: Colors.black),
                      controller: _inputController,
                      decoration: InputDecoration(
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
                        labelText:
                            AppLocalizations.of(context)!.writeYourComment,
                        hintStyle: TextStyle(color: Colors.black),
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
                            return IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                if (_inputController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .writeYourComment)));
                                } else {
                                  await commentStore.createComment(
                                      postId, _inputController.text);
                                  _inputController.clear();

                                  _getData();
                                }
                              },
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      );
    });
  }
}
