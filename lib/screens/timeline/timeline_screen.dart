import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/timeline/components/post_timeline_component.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> with SecureStoreMixin {
  TimelinePostBloc timelineBloc;
  bool loggedIn = false;
  User user;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    timelineBloc = BlocProvider.of<TimelinePostBloc>(context);
    timelineBloc.add(LoadingSucessTimelinePostEvent());
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: " + user.fullname);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 42),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: BlocListener<TimelinePostBloc, TimelinePostState>(
          listener: (context, state) {
            if (state is ErrorState) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: _blocBuilder(),
        ),
      ),
      bottomNavigationBar: NavigatorBar(),
    );
  }

  _blocBuilder() {
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
      builder: (context, state) {
        if (state is InitialState) {
          return Center(
            child: Text("Initial"),
          );
        } else if (state is LoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is LoadedSucessState) {
          return Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    state.posts = [];
                    _getData();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      return PhotoTimeline(
                        post: state.posts[index],
                        timelineBloc: this.timelineBloc,
                        loggedIn: this.loggedIn,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else if (state is ErrorState) {
          return Center(child: Text("Error"));
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'nothing data :(',
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getData() async {
    setState(() {
      timelineBloc.add(LoadingSucessTimelinePostEvent());
    });
  }
}
