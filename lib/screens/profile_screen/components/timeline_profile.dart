import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../shared/secure-store-mixin.dart';

class TimelineScreenProfileScreen extends StatelessWidget {
  List<TimelinePost> posts;
  User user;
  int postSelected;

  TimelineScreenProfileScreen({this.posts, this.postSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicações'),
      ),
      body: ListPostProfileComponent(
        posts: this.posts,
        postSelected: this.postSelected,
      ),
    );
  }
}

class ListPostProfileComponent extends StatefulWidget {
  List<TimelinePost> posts;
  bool loggedIn = false;
  int postSelected;

  ListPostProfileComponent({this.posts, this.loggedIn, this.postSelected});

  @override
  _ListPostProfileComponentState createState() =>
      _ListPostProfileComponentState();
}

class _ListPostProfileComponentState extends State<ListPostProfileComponent>
    with SecureStoreMixin {
  TimelinePostBloc timelineBloc;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  bool loggedIn = false;
  User user;

  @override
  void initState() {
    _checkUserIsLoggedIn();
    timelineBloc = BlocProvider.of<TimelinePostBloc>(context);
    timelineBloc.add(LoadingSucessTimelinePostEvent());
    // jumpTo(widget.postSelected);
    Timer(
      Duration(milliseconds: 300),
      () => itemScrollController.jumpTo(index: widget.postSelected),
    );
  }

  void jumpTo(int index) => itemScrollController.jumpTo(
        index: index,
        alignment: 0,
      );

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: " + user.fullname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: widget.posts.length,
      itemScrollController: this.itemScrollController,
      itemPositionsListener: this.itemPositionsListener,
      itemBuilder: (context, index) {
        print(">>>>>>>> meus posts ${widget.posts[index]}");

        return PhotoTimeline(
          post: widget.posts[index],
          timelineBloc: this.timelineBloc,
          loggedIn: this.loggedIn,
        );
      },
    );
  }
}
