import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/profile_screen/components/timeline_profile_store.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
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
  late TimelinePostBloc timelineBloc;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  late TimelineProfileStore store;

  late FlickMultiManager flickMultiManager;

  bool loggedIn = false;
  User? user;

  int currentPage = 1;
  final int _itemsPerPageCount = 10;
  bool _hasMoreItems = true;
  List<TimelinePost> _allPosts = [];

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    timelineBloc = BlocProvider.of<TimelinePostBloc>(context);
    flickMultiManager = FlickMultiManager();
    _allPosts = widget.posts;

    if (widget.postId == null) {
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
      _allPosts.add(post);
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
    return BlocListener<TimelinePostBloc, TimelinePostState>(
      listener: (context, state) {
        if (state is ErrorState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is LoadedSucessState) {
          _hasMoreItems = state.posts.length == _itemsPerPageCount;
          _allPosts.addAll(state.posts);
          print("PAGINATION ${state.posts.length} ${_allPosts.length}");
        } else if (state is OnDeletedPostState) {
          var indexPost =
              _allPosts.indexWhere((post) => post.id == state.postId);

          if (indexPost >= 0) {
            _allPosts.remove(_allPosts[indexPost]);
          }

          // if (_allPosts.length <= 0) {
          //   Navigator.pop(context, true);
          // }
        } else if (state is OnUpdatePostCommentsCountState) {
          _allPosts
              .firstWhere((post) => post.id == state.postId)
              .commentsCount = state.commentsCount;
        }
      },
      child: _blocBuilder(),
    );
  }

  _blocBuilder() {
    if (widget.postId != null && _allPosts.length > 0) {
      return ScrollablePositionedList.builder(
        itemCount: 1,
        itemScrollController: this.itemScrollController,
        itemPositionsListener: this.itemPositionsListener,
        itemBuilder: (context, index) {
          return PhotoTimeline(
            key: ObjectKey(_allPosts[index]),
            post: _allPosts[index],
            timelineBloc: this.timelineBloc,
            loggedIn: this.loggedIn,
            flickMultiManager: flickMultiManager,
            isProfile: true,
            user: this.user,
          );
        },
      );
    }
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text(AppLocalizations.of(context)!.initial),
          );
        } else if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedSucessState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: VisibilityDetector(
                    key: ObjectKey(flickMultiManager),
                    onVisibilityChanged: (visibility) {
                      if (visibility.visibleFraction == 0 && this.mounted) {
                        flickMultiManager.pause();
                      }
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          _allPosts = [];
                          currentPage = 1;
                        });
                        _getData();
                      },
                      child: ScrollablePositionedList.builder(
                        itemCount: _allPosts.length + (_hasMoreItems ? 1 : 0),
                        itemScrollController: this.itemScrollController,
                        itemPositionsListener: this.itemPositionsListener,
                        itemBuilder: (context, index) {
                          /*if (index == _allPosts.length - _nextPageThreshold &&
                              _hasMoreItems) {}*/
                          if (index == _allPosts.length) {
                            if (_hasMoreItems) {
                              currentPage++;
                              _getData();
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: _hasMoreItems
                                    ? CircularProgressIndicator()
                                    : Container(),
                              ),
                            );
                          }
                          return PhotoTimeline(
                            key: ObjectKey(_allPosts[index]),
                            post: _allPosts[index],
                            timelineBloc: this.timelineBloc,
                            loggedIn: this.loggedIn,
                            flickMultiManager: flickMultiManager,
                            isProfile: true,
                            user: this.user,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ErrorState) {
          return TryAgain(
            _getData,
          );
        }
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
      },
    );
  }

  Future<void> _getData() async {
    if (widget.postId == null) {
      timelineBloc.add(GetTimelinePostsEvent(_itemsPerPageCount,
          (currentPage - 1) * _itemsPerPageCount, widget.userId));
    }
  }
}
