import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/timeline/components/comments/comment_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/theme/light/colors.dart';

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
  bool newCommentLoading = false;
  int currentPage = 1;
  int postCommentsCount = 0;

  List<String> selectedCommentsIds = [];
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await commentStore.getComments(widget.args['post'].id, currentPage);
    });
    postCommentsCount = widget.args['post'].commentsCount;
    this.trackingEvents.timelineViewedComments({
      "postOwnerId": widget.args['post'].userId,
      "commentsCount": widget.args['post'].commentsCount,
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            fillOverscroll: true,
            hasScrollBody: true,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 22,
                              itemBuilder: (context, index) {
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
                                            CircleAvatar(
                                              radius: 19,
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  'data',
                                                  style: TextStyle(
                                                    color: LightColors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  'data',
                                                  style: TextStyle(
                                                    color: LightColors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: LightColors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
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
                Container(
                  color: Color(0xffF8F8F8),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
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
                      labelText: AppLocalizations.of(context)!.writeYourComment,
                      hintStyle: TextStyle(color: Colors.black),
                      suffixIcon: newCommentLoading
                          ? Row(
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
                            )
                          : IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () {},
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
