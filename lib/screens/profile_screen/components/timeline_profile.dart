import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile_store.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimelineScreenProfileScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  TimelineScreenProfileScreen(this.args);

  @override
  _TimelineScreenProfileScreenState createState() =>
      _TimelineScreenProfileScreenState();
}

class _TimelineScreenProfileScreenState
    extends State<TimelineScreenProfileScreen> {
  List<TimelinePost> posts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.args['posts'] != null) {
      this.posts = widget.args['posts'];
    }
    loadingPost();
  }

  loadingPost() {
    Future.delayed(
        Duration(milliseconds: 500),
        () => {
              setState(() => {isLoading = false})
            });
  }

  get appBarProfile => DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.empty,
        ],
        onTapLeading: () => Navigator.pop(context),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.args.containsKey('displayContacts') ? appBarProfile : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(positioned: -50),
            LoadingOverlay(
              isLoading: isLoading,
              child: Visibility(
                visible: !isLoading,
                child: ListPostProfileComponent(
                  posts: this.posts,
                  postSelected: this.widget.args["postSelected"],
                  userId: this.widget.args["userId"],
                  postId: this.widget.args["postId"],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListPostProfileComponent extends StatefulWidget {
  final List<TimelinePost> posts;
  final bool loggedIn = false;
  final int postSelected;
  final String userId;
  final String? postId;

  ListPostProfileComponent({
    required this.userId,
    required this.posts,
    required this.postSelected,
    this.postId,
  });

  @override
  _ListPostProfileComponentState createState() =>
      _ListPostProfileComponentState();
}

class _ListPostProfileComponentState extends State<ListPostProfileComponent>
    with SecureStoreMixin {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late TimelineProfileStore store;

  late FlickMultiManager flickMultiManager;

  TimelineStore timelineStore = TimelineStore();

  bool loggedIn = false;
  User? user;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    flickMultiManager = FlickMultiManager();

    if (widget.postId == null) {
      timelineStore.setProfilePosts(widget.posts);
      Timer(
        Duration(milliseconds: 300),
        () {
          jumpTo();
        },
      );
    } else {
      _performAllRequests();
    }
  }

  jumpTo() => itemScrollController.jumpTo(index: widget.postSelected);

  _performAllRequests() {
    Future.delayed(Duration.zero, () async {
      var post = await store.getPostById(widget.postId!);
      timelineStore.allPosts.add(post);
      setState(() {});
    });
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    store = Provider.of<TimelineProfileStore>(context);
    return Observer(builder: (_) {
      if (widget.postId != null && timelineStore.allPosts.length > 0) {
        return ScrollablePositionedList.builder(
          itemCount: 1,
          itemScrollController: this.itemScrollController,
          itemPositionsListener: this.itemPositionsListener,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PhotoTimeline(
                key: ObjectKey(timelineStore.allPosts[index]),
                post: timelineStore.allPosts[index],
                timelineStore: this.timelineStore,
                loggedIn: this.loggedIn,
                flickMultiManager: flickMultiManager,
                isProfile: true,
                user: this.user,
                onDelete: () => setState(() {}),
              ),
            );
          },
        );
      }
      if (timelineStore.viewState == TimelineViewState.loading) {
        return Center(child: CircularProgressIndicator());
      } else if (timelineStore.viewState == TimelineViewState.error) {
        return TryAgain(
          () => timelineStore.getTimelinePosts(
            null,
            null,
          ),
        );
      } else if (timelineStore.viewState == TimelineViewState.ok &&
          timelineStore.allPosts.length == 0) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.noPosts,
              ),
            ],
          ),
        );
      }
      return Column(
        children: <Widget>[
          Expanded(
            child: VisibilityDetector(
              key: ObjectKey(flickMultiManager),
              onVisibilityChanged: (visibility) {
                if (visibility.visibleFraction == 0 && this.mounted) {
                  flickMultiManager.pause();
                }
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!timelineStore.loadingMorePosts &&
                      timelineStore.viewState != TimelineViewState.loading &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      timelineStore.hasMorePosts) {
                    timelineStore.getTimelinePosts();
                  }
                  return true;
                },
                child: RefreshIndicator(
                  onRefresh: () async {
                    timelineStore.reloadPosts(widget.userId);
                  },
                  child: ScrollablePositionedList.builder(
                    itemCount: timelineStore.allPosts.length,
                    itemScrollController: this.itemScrollController,
                    itemPositionsListener: this.itemPositionsListener,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: PhotoTimeline(
                              key: ObjectKey(timelineStore.allPosts[index]),
                              post: timelineStore.allPosts[index],
                              timelineStore: this.timelineStore,
                              loggedIn: this.loggedIn,
                              flickMultiManager: flickMultiManager,
                              isProfile: true,
                              user: this.user,
                              onDelete: () => setState(() {}),
                            ),
                          ),
                          Observer(
                            builder: (_) => (timelineStore.loadingMorePosts &&
                                    index ==
                                        timelineStore.allPosts.length - 1 &&
                                    timelineStore.hasMorePosts
                                ? SizedBox(
                                    width: double.infinity,
                                    height: 90,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container(
                                    padding: index ==
                                            timelineStore.allPosts.length - 1
                                        ? EdgeInsets.only(bottom: 90)
                                        : null,
                                  )),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
