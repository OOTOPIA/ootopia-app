import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
