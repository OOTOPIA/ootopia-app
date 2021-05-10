import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ootopia_app/bloc/post/post_bloc.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/bloc/user/user_bloc.dart';
import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/data/repositories/wallet_transfers_repository.dart';
import 'package:ootopia_app/data/utils/fetch-data-exception.dart';
import 'package:ootopia_app/screens/components/dialog_confirm.dart';
import 'package:ootopia_app/screens/components/popup_menu_post.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';

import 'feed_player/multi_manager/flick_multi_manager.dart';
import 'feed_player/multi_manager/flick_multi_player.dart';

import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'dart:math' as math;

class PhotoTimeline extends StatefulWidget {
  final int index;
  final TimelinePost post;
  final TimelinePostBloc timelineBloc;
  final User user;
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
      user: this.user);
}

class _PhotoTimelineState extends State<PhotoTimeline> with SecureStoreMixin {
  TimelinePost post;
  final TimelinePostBloc timelineBloc;
  WalletTransfersRepositoryImpl walletTransferRepositoryImpl =
      WalletTransfersRepositoryImpl();
  PostBloc postBloc;
  bool loggedIn = false;
  User user;
  bool isUserOwnsPost = false;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  _PhotoTimelineState({this.post, this.timelineBloc, this.loggedIn, this.user});

  bool dragging = false;

  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  int valueHolder = 20;
  bool _isDragging = false;
  double _draggablePositionX = 0;
  Timer _onDragCanceledTimer;
  double oozGoal = 20;
  bool _sendOOZIsLoading = false;
  bool _oozIsSent = false;
  bool _oozError = false;
  String _oozErrorMessage = "";
  bool _oozSlidingOut = false;

  GlobalKey _slideButtonKey = GlobalKey();
  GlobalKey _oozInfoKey = GlobalKey();

  //final draggableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
    postBloc = BlocProvider.of<PostBloc>(context);
    // _controller = YoutubePlayerController(
    //   initialVideoId: 'MxcJtLbIhvs',
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: true,
    //   ),
    // )..addListener(listener);
    //_videoMetaData = const YoutubeMetaData();
    //_playerState = PlayerState.unknown;
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      if (this.mounted) {
        setState(() {});
      }
    }
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
    //_controller.dispose();
    super.dispose();
  }

  void _goToProfile() async {
    Navigator.of(context).pushNamed(
      user != null && post.userId == user.id
          ? PageRoute.Page.myProfileScreen.route
          : PageRoute.Page.profileScreen.route,
      arguments: {
        "id": user != null && post.userId == user.id ? null : post.userId,
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
            child: FlickMultiPlayer(
              url: this.post.videoUrl,
              flickMultiManager: widget.flickMultiManager,
              image: this.post.thumbnailUrl,
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(GlobalConstants.of(context).spacingSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Stack(
              key: _slideButtonKey,
              children: [
                Positioned(
                  left: 64,
                  child: Opacity(
                    opacity: 1.2 -
                        ((((_draggablePositionX * 100) / 300) / 100)) -
                        0.2,
                    child: Container(
                      margin: EdgeInsets.all(2),
                      padding: EdgeInsets.only(top: 8, left: 6),
                      child: Text(
                        "slide to give a gratitude reward",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(
                            0xffBEBDBD,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  key: _oozInfoKey,
                  right: 0,
                  child: Container(
                    height: 32,
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        this.post.oozToTransfer > 0 &&
                                (_isDragging || _oozIsSent || _oozError) &&
                                !_oozSlidingOut
                            ? Container(
                                margin: EdgeInsets.all(1),
                                child: renderRewardStatus(),
                              )
                            : Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: ImageIcon(
                                  AssetImage(
                                      'assets/icons_profile/ootopia.png'),
                                  color: Colors.black,
                                ),
                              ),
                        Padding(
                          padding: EdgeInsets.all(6),
                          child:
                              Text(this.post.oozToTransfer.toStringAsFixed(2)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _isDragging ? _draggablePositionX : 64,
                  height: 36,
                  decoration: _draggablePositionX > 36
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.blueAccent,
                            ],
                          ),
                        )
                      : BoxDecoration(),
                ),
                Container(
                  width: _isDragging ? _draggablePositionX + 36 : 64,
                  height: 36,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: SizedBox(),
                      ),
                      CustomPaint(
                        painter: CustomContainerShapeBorder(
                          x: _draggablePositionX,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: _draggablePositionX >= 36
                            ? _draggablePositionX - 22
                            : 12,
                        child: Visibility(
                          visible: _isDragging,
                          child: ImageIcon(
                            AssetImage('assets/icons/heart_filled.png'),
                            color: !this.post.liked
                                ? Colors.white
                                : Color(0xffcf0606),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left:
                      _draggablePositionX >= 36 ? _draggablePositionX - 22 : 0,
                  child: Draggable(
                    onDragStarted: () {
                      setState(() {
                        _isDragging = true;
                      });
                    },
                    onDraggableCanceled: (velocity, offset) {
                      //print("Velocity: ${velocity.pixelsPerSecond}");
                      //setState(() {});

                      /**/
                    },
                    onDragUpdate: (details) {
                      if (this.mounted) {
                        setState(() {
                          if (details.localPosition.dx <= getMaxSlideWidth()) {
                            _draggablePositionX = details.localPosition.dx;
                          } else {
                            _draggablePositionX = getMaxSlideWidth();
                          }
                          onSlideButton();
                        });
                      }
                    },
                    axis: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      height: 36.0, // you can adjust the width as you need
                      child: Opacity(
                        opacity: _isDragging ? 0.0 : 1.0,
                        child: IconButton(
                          padding: EdgeInsets.all(0),
                          icon: !this.post.liked
                              ? ImageIcon(
                                  AssetImage('assets/icons/heart_filled.png'),
                                  color: Colors.white,
                                )
                              : ImageIcon(
                                  AssetImage('assets/icons/heart_filled.png'),
                                  color: Color(0xffcf0606),
                                ),
                          onPressed: () => {this._likePost()},
                        ),
                      ),
                    ),
                    feedback: Container(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 3, left: 12, right: 12),
                child: new RichText(
                  text: new TextSpan(
                    style: new TextStyle(fontSize: 14, color: Colors.black),
                    children: <TextSpan>[
                      new TextSpan(text: this.post.likesCount.toString()),
                      new TextSpan(
                        text: ' Likes',
                        style: new TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 3, left: 12, right: 12),
                child: new RichText(
                  text: new TextSpan(
                    style: new TextStyle(fontSize: 14, color: Colors.black),
                    children: <TextSpan>[
                      new TextSpan(
                        text: 'OOz ',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new TextSpan(
                          text: this.post.oozTotalCollected.toStringAsFixed(2)),
                    ],
                  ),
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

  Widget renderRewardStatus() {
    if (_oozIsSent || _oozError) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: (_oozError
              ? Icon(Icons.info, color: Color(0xffDD0606), size: 24)
              : Icon(Icons.check, color: Colors.green.shade600, size: 24)),
          onPressed: () {
            if (_oozError) {
              onClickOOZErrorIcon();
            }
          },
        ),
      );
    }
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.black87,
        padding: EdgeInsets.symmetric(horizontal: 6),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        backgroundColor: Color(0xff0487FF),
      ),
      onPressed: () {
        if (!_sendOOZIsLoading) {
          sendOOZ();
        }
      },
      child: !_sendOOZIsLoading
          ? Text(
              "Send",
              style: TextStyle(
                color: Colors.black,
              ),
            )
          : SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
    );
  }

  void sendOOZ() async {
    setState(() {
      _sendOOZIsLoading = true;
    });
    try {
      await this
          .walletTransferRepositoryImpl
          .transferOOZToPost(this.post.id, this.post.oozToTransfer);
      setState(() {
        _sendOOZIsLoading = false;
        this.post.oozTotalCollected =
            this.post.oozTotalCollected + this.post.oozToTransfer;
      });
      _showOOZIsSent();
    } on FetchDataException catch (e) {
      String errorMessage = e.toString();
      print("Error: ${e.toString()}");
      setState(() {
        _sendOOZIsLoading = false;
        _oozError = true;
        _oozErrorMessage = "An error has occurred. Try again.";
        if (errorMessage == "INSUFFICIENT_BALANCE") {
          _oozErrorMessage = "Your current balance is insuficient";
        }
      });
    }
  }

  void onClickOOZErrorIcon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_oozErrorMessage),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.black87,
      ),
    );
    Timer(Duration(seconds: 1), () {
      setState(() {
        _oozError = false;
      });
      resetSlideButton();
    });
  }

  void _showOOZIsSent() {
    setState(() {
      _oozIsSent = true;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        _oozIsSent = false;
      });
      resetSlideButton();
    });
  }

  double getMaxSlideWidth() {
    final RenderBox renderBox =
        _slideButtonKey.currentContext.findRenderObject();
    final RenderBox renderBoxOOZInfo =
        _oozInfoKey.currentContext.findRenderObject();
    return (renderBox.size.width - renderBoxOOZInfo.size.width) - 26;
  }

  void onSlideButton() {
    double perc = (_draggablePositionX * 100) / getMaxSlideWidth();
    if (_draggablePositionX > 26) {
      this.post.oozToTransfer = ((oozGoal * perc) / 100).roundToDouble();
    } else {
      this.post.oozToTransfer = 0.0;
    }
  }

  void resetSlideButton() {
    setState(() {
      _oozSlidingOut = true;
    });
    _onDragCanceledTimer = Timer.periodic(Duration(milliseconds: 1), (Timer t) {
      setState(() {
        _draggablePositionX = _draggablePositionX - 3;
        if (_draggablePositionX <= 0) {
          _draggablePositionX = 0;
          _onDragCanceledTimer.cancel();
          _isDragging = false;
          _oozSlidingOut = false;
        }
        onSlideButton();
      });
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
            this.trackingEvents.timelineGaveALike(
              {
                "userId": this.post.userId,
              },
            );
            this.post.likesCount = this.post.likesCount + 1;
          } else if (this.post.likesCount > 0) {
            this.trackingEvents.timelineGaveADislike(
              {
                "userId": this.post.userId,
              },
            );
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

class CustomContainerShapeBorder extends CustomPainter {
  final double x;

  CustomContainerShapeBorder({this.x = 0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.shade900;

    double calcPosition = x >= 36 ? x - 36 : 0;

    canvas.translate(calcPosition, 0);

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(
          0,
          0,
          46,
          36,
        ),
        bottomLeft: Radius.circular(100),
        topLeft: Radius.circular(100),
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      ),
      paint,
    );

    canvas.translate(45, 0);

    var path = Path();
    path.lineTo(0, 18);
    path.lineTo(18, 18);
    path.close();
    canvas.drawPath(path, paint);

    var path2 = Path();
    path2.lineTo(18, 18);
    path2.lineTo(0, 36);
    path2.close();
    canvas.drawPath(path2, paint);
    //var path = createPath(3, 36);
    //canvas.drawPath(path, paint..color = Colors.green);
    //canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path createPath(int sides, double radius) {
    var path = Path();
    var angle = (math.pi * 2) / sides;
    path.moveTo(radius * math.cos(0.0), radius * math.sin(0.0));
    for (int i = 1; i <= sides; i++) {
      double x = radius * math.cos(angle * i);
      double y = radius * math.sin(angle * i);
      path.lineTo(x, y);
    }
    path.close();
    return path;
  }
}

// Usar caso seja necessário no futuro, atualmente o player do youtube será desabilitado
// YoutubePlayer(
//   controller: _controller,
//   showVideoProgressIndicator: true,
//   onReady: () {
//     print("ready!!");
//     _isPlayerReady = true;
//     //_controller.addListener(listener);
//   },
// )
