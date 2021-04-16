import 'package:flutter/material.dart';
import 'package:ootopia_app/bloc/post/post_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/screens/components/dialog_confirm.dart';
import 'package:ootopia_app/screens/components/popup_menu_post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

import 'feed_player/multi_manager/flick_multi_manager.dart';
import 'feed_player/multi_manager/flick_multi_player.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PhotoTimeline extends StatefulWidget {
  final int index;
  final TimelinePost post;
  final TimelinePostBloc timelineBloc;
  User user;
  bool loggedIn = false;
  final FlickMultiManager flickMultiManager;
  bool isProfile;

  PhotoTimeline({
    Key key,
    this.index,
    this.post,
    this.timelineBloc,
    this.loggedIn,
    this.user,
    this.flickMultiManager,
    this.isProfile,
  }) : super(key: key);

  @override
  _PhotoTimelineState createState() => _PhotoTimelineState(
        post: this.post,
        timelineBloc: this.timelineBloc,
        loggedIn: this.loggedIn,
      );
}

class _PhotoTimelineState extends State<PhotoTimeline> with SecureStoreMixin {
  TimelinePost post;
  final TimelinePostBloc timelineBloc;
  PostBloc postBloc;
  bool loggedIn = false;
  User user;
  bool isUserOwnsPost = false;

  _PhotoTimelineState({
    this.post,
    this.timelineBloc,
    this.loggedIn,
  });

  bool dragging = false;

  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'MxcJtLbIhvs',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    )..addListener(listener);
    postBloc = BlocProvider.of<PostBloc>(context);
    //_videoMetaData = const YoutubeMetaData();
    //_playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
        //print("CURRENT TIME >>>> ${_controller.value.position.inSeconds}");
        //print("METADATA >>>> ${_videoMetaData.duration.inSeconds}");
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToProfile() async {
    Navigator.of(context).pushNamed(
      PageRoute.Page.profileScreen.route,
      arguments: {
        "id": post.userId,
      },
    );
  }

  // renderSnackBar() {
  //   return ElevatedButton(
  //     child: const Text("You must be logged in and be the owner of this post"),
  //     onPressed: () {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: const Text(
  //               "You must be logged in and be the owner of this post"),
  //           duration: Duration(seconds: 6),
  //           backgroundColor: Colors.yellow,
  //         ),
  //       );
  //     },
  //   );
  // }

  _popupMenuReturn(String selectedOption) {
    print("Meu app >>>> $selectedOption");

    switch (selectedOption) {
      case 'Excluir':
        _showMyDialog();
        break;

      case 'isUserNotOwnsPost':
        // renderSnackBar();
        break;
      default:
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return DialogConfirm(
          textAlert: 'Desejá realmente deletar seu post ?',
          callbackConfirmAlertDialog: _deletePost,
        );
      },
    );
  }

  _deletePost() {
    postBloc.add(DeletePostEvent(widget.post.id, widget.isProfile));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is SuccessDeletePostState) {
          print("chama o evento na timeline");
          this.timelineBloc.add(
                OnDeletePostFromTimelineEvent(state.postId, state.isProfile),
              );
        }
      },
      child: _blocBuilder(),
    );
  }

  _blocBuilder() {
    return BlocBuilder<TimelinePostBloc, TimelinePostState>(
        builder: (context, state) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => _goToProfile(),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: this.post?.photoUrl != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage("${this.post?.photoUrl}"),
                              radius: 16,
                            )
                          : CircleAvatar(
                              backgroundImage: AssetImage(
                                  "assets/icons_profile/profile.png"),
                              radius: 16,
                            ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          this.post.username,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Visibility(
                          visible: (this.post.city != null &&
                                  this.post.city.isNotEmpty) ||
                              (this.post.state != null &&
                                  this.post.state.isNotEmpty),
                          child: Text(
                            '${this.post?.city}' +
                                (this.post.state != null &&
                                        this.post.state.isNotEmpty
                                    ? ', ${this.post?.state}'
                                    : ''),
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuPost(
                isAnabled: isUserOwnsPost,
                callbackReturnPopupMenu: _popupMenuReturn,
                post: post,
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 34,
            margin: EdgeInsets.only(left: 8, right: 8),
            padding: EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Color(0xff1A4188),
            ),
            child: Row(
              children: [
                Text(
                  '#',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: this.post?.tags?.length,
                    itemBuilder: (ctx, index) {
                      return HashtagName(
                        hashtagName: this.post?.tags[index],
                      );
                    },
                  ),
                ),
                // Container(
                //   height: 10,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: <HashtagName>[
                //       HashtagName(
                //         hashtagName: 'flowers',
                //       ),
                //       HashtagName(
                //         hashtagName: 'urbangardening',
                //       ),
                //       HashtagName(
                //         hashtagName: 'saveinsects',
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color(0xff1A4188),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: widget.index == 0
                ? YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    onReady: () {
                      print("ready!!");
                      _isPlayerReady = true;
                      //_controller.addListener(listener);
                    },
                  )
                : FlickMultiPlayer(
                    url: this.post.videoUrl,
                    flickMultiManager: widget.flickMultiManager,
                    image: this.post.thumbnailUrl,
                  ),
          ),
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
                      Navigator.of(context).pushNamed(
                        PageRoute.Page.commentScreen.route,
                        arguments: {
                          "post": this.post,
                        },
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
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3, left: 12),
                child: Row(
                  children: [
                    ImageIcon(
                      AssetImage('assets/icons_profile/ootopia.png'),
                      color: Colors.black,
                    ),
                    Text('13.55')
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible: this.post.description != null &&
                this.post.description.isNotEmpty,
            child: Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 3, left: 12, bottom: 12, right: 12),
                    child: Text(this.post.description),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                PageRoute.Page.commentScreen.route,
                arguments: {
                  "post": this.post,
                },
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 12),
                        child: Text(
                          this.post.commentsCount.toString() + " comments",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.4)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: widget.user?.photoUrl != null
                            ? CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage("${widget.user?.photoUrl}"),
                                  radius: 14,
                                ),
                              )
                            : CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/icons_profile/profile.png"),
                                  radius: 14,
                                ),
                              ),
                      ),
                      Opacity(
                        opacity: .4,
                        child: Text(
                          'Add a comment',
                          style: TextStyle(),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  void _likePost() {
    if (!loggedIn) {
      Navigator.of(context).pushNamed(
        PageRoute.Page.loginScreen.route,
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

class HashtagName extends StatelessWidget {
  String hashtagName;

  HashtagName({this.hashtagName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          this.hashtagName,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
