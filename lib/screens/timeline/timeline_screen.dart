import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/screens/components/navigator_bar.dart';
import 'package:ootopia_app/screens/timeline/components/comment_screen.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    )),
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

class PhotoTimeline extends StatefulWidget {
  final TimelinePost post;
  final TimelinePostBloc timelineBloc;
  bool loggedIn = false;
  PhotoTimeline({this.post, this.timelineBloc, this.loggedIn});

  @override
  _PhotoTimelineState createState() => _PhotoTimelineState(
        post: this.post,
        timelineBloc: this.timelineBloc,
        loggedIn: this.loggedIn,
      );
}

class _PhotoTimelineState extends State<PhotoTimeline> {
  TimelinePost post;
  final TimelinePostBloc timelineBloc;
  bool loggedIn = false;
  _PhotoTimelineState({this.post, this.timelineBloc, this.loggedIn});

  bool dragging = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("${this.post.photoUrl}"),
                      minRadius: 16,
                    ),
                  ),
                  Text(
                    this.post.username,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/options_group.png'),
                  color: Colors.black12,
                ),
                onPressed: null,
              ),
            ],
          ),
          PlayerVideo(url: this.post.videoUrl),
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                      icon: !this.post.liked
                          ? ImageIcon(
                              AssetImage('assets/icons/heart.png'),
                              color: Colors.black87,
                            )
                          : ImageIcon(
                              AssetImage('assets/icons/heart_filled.png'),
                              color: Theme.of(context).accentColor,
                            ),
                      onPressed: () => {this._likePost()}),
                  IconButton(
                    icon: ImageIcon(
                      AssetImage('assets/icons/comment.png'),
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(
                            post: this.post,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage('assets/icons/bookmark.png'),
                  color: Colors.black12,
                ),
                onPressed: null,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 3, left: 12),
                  child: new RichText(
                    text: new TextSpan(
                      style: new TextStyle(fontSize: 14, color: Colors.black),
                      children: <TextSpan>[
                        new TextSpan(
                            text: 'Likes ',
                            style: new TextStyle(fontWeight: FontWeight.bold)),
                        new TextSpan(text: this.post.likesCount.toString()),
                      ],
                    ),
                  ))
            ],
          ),
          Row(
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 3, left: 12, bottom: 12, right: 12),
                child: Text(this.post.description),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12, left: 12),
                child: Text(
                  "0 comments",
                  style: TextStyle(color: Colors.black.withOpacity(0.4)),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _likePost() {
    if (!loggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        this.timelineBloc.add(LikePostEvent(this.post.id));
        this.post.liked = !this.post.liked;
        if (this.post.liked) {
          this.post.likesCount = this.post.likesCount + 1;
        } else if (this.post.likesCount > 0) {
          this.post.likesCount = this.post.likesCount - 1;
        }
      });
    }
  }
}

/*
Draggable(
  data: "teste",
  onDragStarted: () {
    setState(() {
      //dragging = true;
    });
  },
  axis: Axis.horizontal,
  child: Visibility(
    visible: !dragging,
    child: IconButton(
      icon: ImageIcon(
        AssetImage('assets/icons/heart.png'),
        color: Colors.black12,
      ),
      onPressed: () {},
    ),
  ),
  feedback: Container(
      margin: const EdgeInsets.only(top: 12),
      child: ImageIcon(
        AssetImage('assets/icons/heart_filled.png'),
        color: Color(0xff0253e7),
      )))
*/

class PlayerVideo extends StatefulWidget {
  String url;

  PlayerVideo({this.url});

  @override
  _PlayerVideoState createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void myFunc() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });

    print(_controller);
  }

  iconPlayAndPause() {
    if (_controller.value.isPlaying) {
      return Visibility(
        child: Icon(Icons.pause),
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: false,
      );
    } else {
      return Icon(Icons.play_arrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: double.infinity,
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(
                  alignment: AlignmentDirectional.center,
                  height: 200,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
        IconButton(
          icon: iconPlayAndPause(),
          color: Colors.white,
          onPressed: myFunc,
        )
      ],
    );
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
