import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerLearningTracks extends StatefulWidget {
  VideoPlayerLearningTracks();

  @override
  _VideoPlayerLearningTracksState createState() =>
      _VideoPlayerLearningTracksState();
}

class _VideoPlayerLearningTracksState extends State<VideoPlayerLearningTracks> {
  late VideoPlayerController videoPlayerController;

  Timer? timerOpacity;
  String totalTimeVideoText = '';
  String positionVideoText = '';
  int currentPosition = 0;
  double maxDurationVideo = 0;
  bool onChangedStart = false;

  String timeVideo(Duration time) {
    String hoursInString =
        time.inHours == 0 ? '' : time.inHours.toString() + ":";

    String minutesInString = time.inMinutes.toString().length > 1
        ? time.inMinutes.remainder(60).toString()
        : '0${time.inMinutes.remainder(60).toString()}';

    String secondsInString = time.inSeconds.toString().length > 1
        ? time.inSeconds.toString().substring(0, 2)
        : '0${time.inSeconds.toString()}';

    return "$hoursInString$minutesInString:$secondsInString";
  }

  @override
  void initState() {
    super.initState();

    videoPlayerController =
        VideoPlayerController.asset('assets/videos/ootopia_learning.mp4')
          ..addListener(() {
            if (mounted) {
              setState(() {
                maxDurationVideo =
                    videoPlayerController.value.duration.inSeconds.toDouble();
                totalTimeVideoText =
                    timeVideo(videoPlayerController.value.duration);
                positionVideoText =
                    timeVideo(videoPlayerController.value.position);
                currentPosition =
                    videoPlayerController.value.position.inSeconds;
              });
            }
          })
          ..initialize().then((value) {
            videoPlayerController.play();
          });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    print(args);
    return Stack(
      children: [
        VideoPlayer(videoPlayerController),
        Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            opacity: timerOpacity != null ? 1 : 0.0,
            duration: Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  videoPlayerController.value.isPlaying
                      ? videoPlayerController.pause()
                      : videoPlayerController.play();

                  timerOpacity?.cancel();
                  timerOpacity = Timer(
                    Duration(seconds: 1),
                    () => setState(() => timerOpacity = null),
                  );
                });
              },
              child: CircleAvatar(
                backgroundColor: Color(0xff35AD6C),
                radius: 28.5,
                child: Icon(
                  (videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow),
                  size: 23,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              setState(() {
                timerOpacity?.cancel();
                timerOpacity = Timer(
                  Duration(seconds: 1),
                  () => setState(() => timerOpacity = null),
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
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 6.5),
                        trackShape: CustomTrackShape(),
                      ),
                      child: Slider(
                        inactiveColor: Color(0xffCDCDCD),
                        activeColor: Color(0xff35ad6c),
                        thumbColor: Color(0xff35ad6c),
                        min: 0,
                        max: maxDurationVideo,
                        value: currentPosition.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            totalTimeVideoText =
                                timeVideo(videoPlayerController.value.duration);
                            positionVideoText =
                                timeVideo(videoPlayerController.value.position);
                            currentPosition = value.toInt();
                          });
                        },
                        onChangeStart: (value) {
                          setState(() {
                            onChangedStart = true;
                          });
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            onChangedStart = false;
                            currentPosition = value.toInt();
                          });
                          videoPlayerController
                              .seekTo(Duration(seconds: value.toInt()));
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
