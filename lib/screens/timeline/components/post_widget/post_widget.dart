import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/last_learning_track_component.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';

class PostWidget extends StatelessWidget {
  final int index;
  final TimelinePost post;
  final TimelineStore timelineStore;
  final bool loggedIn;
  final User? user;
  final FlickMultiManager flickMultiManager;
  final action;


  const PostWidget({
    Key? key,
    required this.index,
    required this.post,
    required this.timelineStore,
    required this.loggedIn,
    required this.user,
    required this.flickMultiManager,
    required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (index == 0) LastLearningTrackComponents(),
        PhotoTimeline(
          key: ObjectKey(post),
          index: index,
          post: post,
          timelineStore: timelineStore,
          loggedIn: loggedIn,
          user: user,
          flickMultiManager: flickMultiManager,
          isProfile: false,
          onDelete: () => action,//setState(() {}),
        ),
        if(isLastPost())...[
          Observer(
            builder: (_) => ( showLoading()
                ? SizedBox(
              width: double.infinity,
              height: 90,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : SizedBox(
              height: isLastPost() ? 90 : 0,
            )),
          ),
        ]
      ],
    );
  }


  bool isLastPost(){
    return index == timelineStore.allPosts.length - 1;
  }

  bool showLoading(){
    return timelineStore.loadingMorePosts  && timelineStore.hasMorePosts;
  }

}

