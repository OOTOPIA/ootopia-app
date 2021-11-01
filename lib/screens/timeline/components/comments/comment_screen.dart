import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
      await commentStore.getComments(postId, currentPage);
      homeStore.setSeeCrip(false);
      setState(() {});
    });
    postCommentsCount = widget.args['post'].commentsCount;
    this.trackingEvents.timelineViewedComments({
      "postOwnerId": widget.args['post'].userId,
      "commentsCount": widget.args['post'].commentsCount,
    });
  }

  Future<void> _getData() async {
    await commentStore.getComments(postId, currentPage);
  }

  @override
  Widget build(BuildContext context) {
    homeStore = Provider.of<HomeStore>(context);
    authStore = Provider.of<AuthStore>(context);

    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _getData,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.81,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  children: [
                    Container(
                      color: LightColors.grey.withOpacity(0.05),
                      width: double.infinity,
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
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.65,
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
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
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  comment.photoUrl == 'null' ||
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
                                                          color:
                                                              LightColors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        comment.text,
                                                        style: TextStyle(
                                                          color:
                                                              LightColors.black,
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
                                                  onTap: () {
                                                    commentStore.deleteComments(
                                                        postId, 1);
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
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    authStore.currentUser == null
                        ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PageRoute.Page.loginScreen.route,
                                arguments: {
                                  "returnToPageWithArgs": {
                                    "currentPageName": "wallet",
                                    "arguments": null
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                focusNode: FocusNode(),
                                onTap: () {
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
                                },
                                scrollPhysics: NeverScrollableScrollPhysics(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: LightColors.grey, width: 0.25),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: LightColors.grey, width: 0.25),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: LightColors.grey, width: 0.25),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelText: AppLocalizations.of(context)!
                                      .writeYourComment,
                                  hintStyle: TextStyle(color: Colors.black),
                                  suffixIcon: Icon(Icons.send),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Color(0xffF8F8F8),
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _inputController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: LightColors.grey, width: 0.25),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: LightColors.grey, width: 0.25),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: LightColors.grey, width: 0.25),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: AppLocalizations.of(context)!
                                    .writeYourComment,
                                hintStyle: TextStyle(color: Colors.black),
                                suffixIcon: Observer(builder: (context) {
                                  if (commentStore.isLoading) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 14.0),
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
                                        await commentStore.createComment(
                                            postId, _inputController.text);
                                      },
                                    );
                                  }
                                }),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
