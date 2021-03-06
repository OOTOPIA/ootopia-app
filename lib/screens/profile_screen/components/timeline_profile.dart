import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/try_again.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../shared/secure-store-mixin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimelineScreenProfileScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  TimelineScreenProfileScreen(this.args);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.publications),
      ),
      body: ListPostProfileComponent(
          posts: this.args["posts"],
          postSelected: this.args["postSelected"],
          userId: this.args["userId"]),
      bottomNavigationBar: NavigatorBar(),
    );
  }
}

class ListPostProfileComponent extends StatefulWidget {
  List<TimelinePost> posts;
  bool loggedIn = false;
  int postSelected;
  String userId;

  ListPostProfileComponent({
    required this.userId,
    required this.posts,
    required this.postSelected,
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

  late FlickMultiManager flickMultiManager;

  bool loggedIn = false;
  User? user;

  int currentPage = 1;
  final int _itemsPerPageCount = 10;
  int _nextPageThreshold = 5;
  bool _hasMoreItems = true;
  List<TimelinePost> _allPosts = [];

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    timelineBloc = BlocProvider.of<TimelinePostBloc>(context);
    flickMultiManager = FlickMultiManager();
    _allPosts = widget.posts;

    Timer(
      Duration(milliseconds: 300),
      () {
        jumpTo();
      },
    );
  }

  jumpTo() => itemScrollController.jumpTo(index: widget.postSelected);

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: " + user!.fullname!);
    }
  }

  @override
  Widget build(BuildContext context) {
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
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text(AppLocalizations.of(context)!.initial),
          );
        } else if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedSucessState) {
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
    timelineBloc.add(GetTimelinePostsEvent(_itemsPerPageCount,
        (currentPage - 1) * _itemsPerPageCount, widget.userId));
  }
}
