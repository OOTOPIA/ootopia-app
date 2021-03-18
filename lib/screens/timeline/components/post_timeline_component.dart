import 'package:flutter/material.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/screens/auth/login_screen.dart';
import 'package:ootopia_app/screens/timeline/components/comment_screen.dart';
import 'package:ootopia_app/screens/timeline/components/player_video_component.dart';

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
                child: GestureDetector(
                  onTap: () => CommentScreen(
                    post: this.post,
                  ),
                  child: Text(
                    this.post.commentsCount.toString() + " comments",
                    style: TextStyle(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              ),
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
      setState(
        () {
          this.timelineBloc.add(LikePostEvent(this.post.id));
          this.post.liked = !this.post.liked;
          if (this.post.liked) {
            this.post.likesCount = this.post.likesCount + 1;
          } else if (this.post.likesCount > 0) {
            this.post.likesCount = this.post.likesCount - 1;
          }
        },
      );
    }
  }
}
