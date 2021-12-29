import 'dart:async';
import 'dart:ui';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/player_video_fullscreen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock/wakelock.dart';

class VideoPlayerLearningTracks extends StatefulWidget {
  final String videoUrl;
  final String thumbVideo;
  final Widget viewQuiz;
  final Function updateStatusVideo;

  VideoPlayerLearningTracks({
    required this.videoUrl,
    required this.thumbVideo,
    required this.viewQuiz,
    required this.updateStatusVideo,
  });

  @override
  _VideoPlayerLearningTracksState createState() =>
      _VideoPlayerLearningTracksState();
}

class _VideoPlayerLearningTracksState extends State<VideoPlayerLearningTracks> {
  late VideoPlayerController videoPlayerController;
  late FlickMultiManager flickMultiManager;
  late FlickManager flickManager;

  Timer? timerOpacity;
  String totalTimeVideoText = '';
  String positionVideoText = '';
  int currentPosition = 0;
  double maxDurationVideo = 0;
  var widthVideo = 1.0;
  var heightVideo = 1.0;
  bool isLoading = false;
  bool fullScreenVideo = false;
  bool isWakelock = false;

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
    setState(() {
      isLoading = true;
    });

    flickMultiManager = FlickMultiManager();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        flickManager = FlickManager(
          videoPlayerController: videoPlayerController,
        );
        if (mounted) {
          setState(() {
            maxDurationVideo =
                videoPlayerController.value.duration.inSeconds.toDouble();
            totalTimeVideoText =
                timeVideo(videoPlayerController.value.duration);
            positionVideoText = timeVideo(videoPlayerController.value.position);
            currentPosition = videoPlayerController.value.position.inSeconds;
            widthVideo = videoPlayerController.value.size.width;
            heightVideo = videoPlayerController.value.size.height;
          });
          if (!isWakelock && videoPlayerController.value.isPlaying) {
            Wakelock.enable();
            isWakelock = true;
          } else {
            if (!videoPlayerController.value.isPlaying) {
              Wakelock.disable();
              isWakelock = false;
            }
          }
        }
      })
      ..initialize().then((value) {
        setState(() {
          timerOpacity?.cancel();
          timerOpacity = Timer(
            Duration(seconds: 1),
            () => setState(() => timerOpacity = null),
          );
          isLoading = false;
        });
        videoPlayerController.play();

        videoPlayerController.addListener(() {
          //custom Listner
          setState(() {
            if (videoPlayerController.value.isInitialized &&
                (videoPlayerController.value.duration ==
                    videoPlayerController.value.position)) {
              //checking the duration and position every time
              //Video Completed//
              widget.updateStatusVideo();
            }
          });
        });
      });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    Wakelock.disable();
    super.dispose();
  }

  bool onClickSlider = false;
  double heightPlayerVideo = 0.0;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      if (widthVideo > heightVideo) {
        heightPlayerVideo =
            MediaQuery.of(context).size.width / (widthVideo / heightVideo);
      } else {
        heightPlayerVideo = MediaQuery.of(context).size.height * 0.75;
      }
    } else {
      heightPlayerVideo = MediaQuery.of(context).size.height;
    }
    return LoadingOverlay(
      isLoading: isLoading,
      child: OrientationBuilder(builder: (context, orientation) {
        print("object ${orientation}");
        if (!fullScreenVideo)
          return VisibilityDetector(
            key: Key('${videoPlayerController.dataSource}'),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction == 0 && this.mounted) {
                videoPlayerController.pause();
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
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
                      width: MediaQuery.of(context).size.width,
                      height: heightPlayerVideo,
                      child: Container(
                        child: Stack(
                          children: [
                            Image.network(
                              widget.thumbVideo,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 40,
                                  sigmaY: 40,
                                ),
                                child: Container(
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: heightPlayerVideo,
                              child: AspectRatio(
                                aspectRatio: widthVideo / heightVideo,
                                child: VideoPlayer(videoPlayerController),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: onClickSlider
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xff35AD6C),
                                      ),
                                    )
                                  : AnimatedOpacity(
                                      opacity: timerOpacity != null ? 1 : 0.0,
                                      duration: Duration(milliseconds: 200),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            videoPlayerController
                                                    .value.isPlaying
                                                ? videoPlayerController.pause()
                                                : videoPlayerController.play();
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Color(0xff35AD6C),
                                          radius: 28.5,
                                          child: Icon(
                                            (videoPlayerController
                                                    .value.isPlaying
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
                              child: AnimatedOpacity(
                                opacity: timerOpacity != null ? 1 : 0.0,
                                duration: Duration(milliseconds: 200),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      timerOpacity?.cancel();
                                      timerOpacity = Timer(
                                        Duration(seconds: 1),
                                        () =>
                                            setState(() => timerOpacity = null),
                                      );
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24),
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
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 6.5),
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
                                                await videoPlayerController
                                                    .pause();
                                                setState(() {
                                                  onClickSlider = true;
                                                  Future.delayed(
                                                      Duration(
                                                          milliseconds: 300),
                                                      () {
                                                    onClickSlider = false;
                                                  });
                                                });
                                              },
                                              onChanged: (value) async {
                                                setState(() {
                                                  totalTimeVideoText =
                                                      timeVideo(
                                                          videoPlayerController
                                                              .value.duration);

                                                  positionVideoText = timeVideo(
                                                      videoPlayerController
                                                          .value.position);
                                                  currentPosition =
                                                      value.toInt();
                                                  onClickSlider = false;
                                                });
                                                await videoPlayerController
                                                    .seekTo(Duration(
                                                        seconds:
                                                            value.toInt()));
                                              },
                                              onChangeEnd: (value) async {
                                                setState(() {
                                                  onClickSlider = false;
                                                });
                                                await videoPlayerController
                                                    .play();
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
                                            if (!fullScreenVideo) {
                                              SystemChrome
                                                  .setPreferredOrientations([
                                                DeviceOrientation
                                                    .landscapeRight,
                                                DeviceOrientation.landscapeLeft,
                                              ]);
                                              fullScreenVideo = true;
                                              return;
                                            }

                                            SystemChrome
                                                .setPreferredOrientations([
                                              DeviceOrientation.portraitUp,
                                              DeviceOrientation.portraitDown
                                            ]);
                                            fullScreenVideo = false;
                                          },
                                          icon: ImageIcon(
                                              AssetImage(
                                                  "assets/icons/icon_maximizescreen.png"),
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
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.viewQuiz,
                ],
              ),
            ),
          );
        else
          return Container(
            child: FlickVideoPlayer(
              preferredDeviceOrientationFullscreen: [],
              flickManager: flickManager,
              flickVideoWithControls: FlickVideoWithControls(
                  controls: PlayerControls(
                flickMultiManager: flickMultiManager,
                flickManager: flickManager,
              )),
            ),
          );
      }),
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
