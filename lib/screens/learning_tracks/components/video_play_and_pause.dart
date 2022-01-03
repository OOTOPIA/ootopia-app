import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class VideoPlayAndPause extends StatefulWidget {
  VideoPlayerController? videoPlayerController;
  Timer? timerOpacity;
  bool onClickSlider;
  bool disablePreviusVideo;
  bool disableNextVideo;
  Function eventNextVideo;
  Function eventPreviusVideo;

  VideoPlayAndPause({
    Key? key,
    required this.videoPlayerController,
    required this.onClickSlider,
    required this.disablePreviusVideo,
    required this.disableNextVideo,
    required this.eventNextVideo,
    required this.eventPreviusVideo,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.eventPreviusVideo();
                  },
                  child: Opacity(
                    opacity: widget.disablePreviusVideo ? .40 : 1,
                    child: SvgPicture.asset("assets/icons/previus_video.svg"),
                  ),
                ),
                SizedBox(
                  width: 36,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.videoPlayerController != null) {
                        widget.videoPlayerController!.value.isPlaying
                            ? widget.videoPlayerController!.pause()
                            : widget.videoPlayerController!.play();
                      }
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(0xff35AD6C),
                    radius: 28.5,
                    child: Icon(
                      (widget.videoPlayerController != null &&
                              widget.videoPlayerController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                      size: 23,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 36,
                ),
                GestureDetector(
                  onTap: () {
                    widget.eventNextVideo();
                  },
                  child: Opacity(
                    opacity: widget.disableNextVideo ? .40 : 1,
                    child: SvgPicture.asset("assets/icons/next_video.svg"),
                  ),
                ),
              ],
            ),
          );
  }
}
