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
      commentStore.getComments('postId', currentPage);
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
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ),
                Container(
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
              ],
            ),
          )
        ],
      )),
    );
  }
}
