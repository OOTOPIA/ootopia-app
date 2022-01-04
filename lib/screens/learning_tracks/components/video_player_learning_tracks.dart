import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/learning_tracks/components/video_bar.dart';
import 'package:ootopia_app/screens/learning_tracks/components/video_play_and_pause.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerLearningTracks extends StatefulWidget {
  final String videoUrl;
  final String thumbVideo;
  final Widget viewQuiz;
  final Function updateStatusVideo;
  final Function eventFullScreen;
  VideoPlayerLearningTracks(
      {required this.videoUrl,
      required this.thumbVideo,
      required this.viewQuiz,
      required this.updateStatusVideo,
      required this.eventFullScreen});

  @override
  _VideoPlayerLearningTracksState createState() =>
      _VideoPlayerLearningTracksState();
}

class _VideoPlayerLearningTracksState extends State<VideoPlayerLearningTracks> {
  late VideoPlayerController videoPlayerController;
  Timer? timerOpacity;
  var widthVideo = 1.0;
  var heightVideo = 1.0;
  bool isLoading = false;
  bool fullScreenVideo = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });

    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (mounted) {
          setState(() {
            widthVideo = videoPlayerController.value.size.width;
            heightVideo = videoPlayerController.value.size.height;
          });
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  bool onClickSlider = false;
  double heightPlayerVideo = 0.0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (!fullScreenVideo) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          if (MediaQuery.of(context).orientation == Orientation.portrait) {
            if (widthVideo > heightVideo) {
              heightPlayerVideo = MediaQuery.of(context).size.width /
                  (widthVideo / heightVideo);
            } else {
              heightPlayerVideo = MediaQuery.of(context).size.height * 0.75;
            }
          } else {
            heightPlayerVideo = MediaQuery.of(context).size.height;
          }
        } else {
          heightPlayerVideo = MediaQuery.of(context).size.height;
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        }
        return LoadingOverlay(
          isLoading: isLoading,
          child: VisibilityDetector(
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
                              child: VideoPlayAndPause(
                                onClickSlider: onClickSlider,
                                videoPlayerController: videoPlayerController,
                                timerOpacity: timerOpacity,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: VideoBar(
                                videoPlayerController: videoPlayerController,
                                fullScreenVideo: fullScreenVideo,
                                fullScreenEvent: () {
                                  fullScreenVideo = !fullScreenVideo;
                                  widget.eventFullScreen();
                                },
                                loadingTimeLineVideo: (bool value) {
                                  setState(() {
                                    onClickSlider = value;
                                  });
                                },
                                timerOpacity: timerOpacity,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!fullScreenVideo) widget.viewQuiz,
                ],
              ),
            ),
          ),
        );
      },
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
