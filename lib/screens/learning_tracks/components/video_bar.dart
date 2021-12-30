import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/learning_tracks/components/video_player_learning_tracks.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class VideoBar extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  Timer? timerOpacity;
  Function loadingTimeLineVideo;
  Function fullScreenEvent;
  bool fullScreenVideo;

  VideoBar({
    Key? key,
    required this.videoPlayerController,
    required this.loadingTimeLineVideo,
    required this.fullScreenEvent,
    required this.fullScreenVideo,
    this.timerOpacity,
  }) : super(key: key);

  @override
  _VideoBarState createState() => _VideoBarState();
}

class _VideoBarState extends State<VideoBar> {
  String totalTimeVideoText = '';
  String positionVideoText = '';
  int currentPosition = 0;
  double maxDurationVideo = 0;
  bool isWakelock = false;
  var widthVideo = 1.0;
  var heightVideo = 1.0;

  String timeVideo(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours =
        time.inHours == 0 ? '' : twoDigits(time.inHours.remainder(60)) + ':';
    String twoDigitMinutes = twoDigits(time.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(time.inSeconds.remainder(60));
    return "$twoDigitHours$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    super.initState();

    widget.videoPlayerController
      ..addListener(() {
        if (mounted) {
          setState(() {
            maxDurationVideo = widget
                .videoPlayerController.value.duration.inSeconds
                .toDouble();
            totalTimeVideoText =
                timeVideo(widget.videoPlayerController.value.duration);
            positionVideoText =
                timeVideo(widget.videoPlayerController.value.position);
            currentPosition =
                widget.videoPlayerController.value.position.inSeconds;
            widthVideo = widget.videoPlayerController.value.size.width;
            heightVideo = widget.videoPlayerController.value.size.height;
          });
          if (!isWakelock && widget.videoPlayerController.value.isPlaying) {
            Wakelock.enable();
            isWakelock = true;
          } else {
            if (!widget.videoPlayerController.value.isPlaying) {
              Wakelock.disable();
              isWakelock = false;
            }
          }
        }
      })
      ..initialize().then((value) {
        setState(() {
          widget.timerOpacity?.cancel();
          widget.timerOpacity = Timer(
            Duration(seconds: 1),
            () => setState(() => widget.timerOpacity = null),
          );
        });
      });
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.timerOpacity != null ? 1 : 0.0,
      duration: Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.timerOpacity?.cancel();
            widget.timerOpacity = Timer(
              Duration(seconds: 1),
              () => setState(() => widget.timerOpacity = null),
            );
          });
        },
        child: Container(
          height: 40,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$positionVideoText',
                style: TextStyle(
                  color: Color(0xffCDCDCD),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.5),
                    trackShape: CustomTrackShape(),
                  ),
                  child: Slider(
                    inactiveColor: Color(0xffCDCDCD),
                    activeColor: Color(0xff35ad6c),
                    thumbColor: Color(0xff35ad6c),
                    min: 0,
                    max: maxDurationVideo,
                    value: currentPosition.toDouble(),
                    onChangeStart: (value) async {
                      await widget.videoPlayerController.pause();
                      setState(() {
                        widget.loadingTimeLineVideo(true);
                        Future.delayed(Duration(milliseconds: 300), () {
                          widget.loadingTimeLineVideo(false);
                        });
                      });
                    },
                    onChanged: (value) async {
                      setState(() {
                        totalTimeVideoText = timeVideo(
                            widget.videoPlayerController.value.duration);

                        positionVideoText = timeVideo(
                            widget.videoPlayerController.value.position);
                        currentPosition = value.toInt();
                        widget.loadingTimeLineVideo(false);
                      });
                      await widget.videoPlayerController
                          .seekTo(Duration(seconds: value.toInt()));
                    },
                    onChangeEnd: (value) async {
                      setState(() {
                        widget.loadingTimeLineVideo(false);
                      });
                      await widget.videoPlayerController.play();
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '$totalTimeVideoText',
                style: TextStyle(
                  color: Color(0xffCDCDCD),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  widget.fullScreenEvent();
                },
                icon: widget.fullScreenVideo
                    ? ImageIcon(
                        AssetImage("assets/icons/icon_minimizescreen.png"),
                        color: Color(0xFFCDCDCD),
                        size: 16)
                    : ImageIcon(
                        AssetImage("assets/icons/icon_maximizescreen.png"),
                        color: Color(0xFFCDCDCD),
                        size: 16),
              ),
              Text(
                '$totalTimeVideoText',
                style: TextStyle(
                  color: Color(0xffCDCDCD),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
