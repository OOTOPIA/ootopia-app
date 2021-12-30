import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayAndPause extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  Timer? timerOpacity;
  bool onClickSlider;

  VideoPlayAndPause({
    Key? key,
    required this.videoPlayerController,
    required this.onClickSlider,
    this.timerOpacity,
  }) : super(key: key);

  @override
  _VideoPlayPauseState createState() => _VideoPlayPauseState();
}

class _VideoPlayPauseState extends State<VideoPlayAndPause> {
  @override
  Widget build(BuildContext context) {
    return widget.onClickSlider
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xff35AD6C),
            ),
          )
        : AnimatedOpacity(
            opacity: widget.timerOpacity != null ? 1 : 0.0,
            duration: Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.videoPlayerController.value.isPlaying
                      ? widget.videoPlayerController.pause()
                      : widget.videoPlayerController.play();
                });
              },
              child: CircleAvatar(
                backgroundColor: Color(0xff35AD6C),
                radius: 28.5,
                child: Icon(
                  (widget.videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  size: 23,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}
