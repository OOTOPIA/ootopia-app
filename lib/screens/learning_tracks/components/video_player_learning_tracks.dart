import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:wakelock/wakelock.dart';
import 'package:ootopia_app/data/models/learning_tracks/chapters_model.dart';
import 'package:ootopia_app/screens/learning_tracks/components/video_bar.dart';
import 'package:ootopia_app/screens/learning_tracks/components/video_play_and_pause.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerLearningTracks extends StatefulWidget {
  final Widget viewQuiz;
  final ChaptersModel chapter;
  final Function updateStatusVideo;
  final Function eventFullScreen;
  final Function? eventNextVideo;
  final Function? eventPreviusVideo;
  final List<ChaptersModel>? listChapters;

  VideoPlayerLearningTracks({
    required this.chapter,
    required this.viewQuiz,
    required this.updateStatusVideo,
    required this.eventFullScreen,
    this.eventNextVideo,
    this.eventPreviusVideo,
    this.listChapters,
  });

  @override
  _VideoPlayerLearningTracksState createState() =>
      _VideoPlayerLearningTracksState();
}

class _VideoPlayerLearningTracksState extends State<VideoPlayerLearningTracks> {
  late VideoPlayerController? videoPlayerController;
  late ChaptersModel currentChapter;
  Timer? timerOpacity;
  var widthVideo = 1.0;
  var heightVideo = 1.0;
  bool isLoading = false;
  bool fullScreenVideo = false;

  String totalTimeVideoText = '';
  String positionVideoText = '';
  int currentPosition = 0;
  double maxDurationVideo = 0;
  bool isWakelock = false;

  String timeVideo(Duration time) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours =
        time.inHours == 0 ? '' : twoDigits(time.inHours.remainder(60)) + ':';
    String twoDigitMinutes = twoDigits(time.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(time.inSeconds.remainder(60));
    return "$twoDigitHours$twoDigitMinutes:$twoDigitSeconds";
  }

  setOrientationVideo(Orientation orientation) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    if (!fullScreenVideo) {
      if (orientation == Orientation.portrait) {
        if (widthVideo > heightVideo) {
          heightPlayerVideo =
              MediaQuery.of(context).size.width / (widthVideo / heightVideo);
        } else {
          heightPlayerVideo = MediaQuery.of(context).size.height * 0.75;
        }
      } else {
        heightPlayerVideo = MediaQuery.of(context).size.height;
      }
    } else {
      heightPlayerVideo = MediaQuery.of(context).size.height;
    }
  }

  @override
  void initState() {
    super.initState();
    currentChapter = widget.chapter;
    startVideFirst();
  }

  startVideFirst() {
    setState(() {
      isLoading = true;
    });
    videoPlayerController =
        VideoPlayerController.network(currentChapter.videoUrl)
          ..addListener(startVideo)
          ..initialize().then((value) {
            setState(() {
              timerOpacity?.cancel();
              timerOpacity = Timer(
                Duration(seconds: 1),
                () => setState(() => timerOpacity = null),
              );
              isLoading = false;
            });
            videoPlayerController!.play();
          });
  }

  startVideo() {
    if (mounted) {
      setState(() {
        if (videoPlayerController != null) {
          widthVideo = videoPlayerController!.value.size.width;
          heightVideo = videoPlayerController!.value.size.height;
          maxDurationVideo =
              videoPlayerController!.value.duration.inSeconds.toDouble();
          totalTimeVideoText = timeVideo(videoPlayerController!.value.duration);
          positionVideoText = timeVideo(videoPlayerController!.value.position);
          currentPosition = videoPlayerController!.value.position.inSeconds;
          widthVideo = videoPlayerController!.value.size.width;
          heightVideo = videoPlayerController!.value.size.height;
        }

        if (videoPlayerController!.value.isInitialized &&
            (videoPlayerController!.value.duration ==
                videoPlayerController!.value.position)) {
          //checking the duration and position every time
          //Video Completed//
          widget.updateStatusVideo();
        }
      });
    }

    if (!isWakelock && videoPlayerController!.value.isPlaying) {
      Wakelock.enable();
      isWakelock = true;
    } else {
      if (!videoPlayerController!.value.isPlaying) {
        Wakelock.disable();
        isWakelock = false;
      }
    }
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  bool onClickSlider = false;
  double heightPlayerVideo = 0.0;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      setOrientationVideo(orientation);
      return LoadingOverlay(
        isLoading: isLoading,
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
                    child: videoPlayerController != null
                        ? Container(
                            child: Stack(
                              children: [
                                Image.network(
                                  widget.chapter.videoThumbUrl,
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
                                    child: VideoPlayer(videoPlayerController!),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: VideoPlayAndPause(
                                    disableNextVideo: !(widget.listChapters !=
                                            null &&
                                        widget.listChapters!.indexWhere(
                                                (_chapter) =>
                                                    _chapter.id ==
                                                    currentChapter.id) <
                                            (widget.listChapters!.length - 1)),
                                    disablePreviusVideo:
                                        !(widget.listChapters != null &&
                                            widget.listChapters!.indexWhere(
                                                    (_chapter) =>
                                                        _chapter.id ==
                                                        currentChapter.id) >
                                                0),
                                    eventNextVideo: () {
                                      if (widget.listChapters != null &&
                                          widget.listChapters!.indexWhere(
                                                  (_chapter) =>
                                                      _chapter.id ==
                                                      currentChapter.id) <
                                              (widget.listChapters!.length -
                                                  1)) {
                                        videoPlayerController!.pause();
                                        int currentIndex = widget.listChapters!
                                            .indexWhere((_chapter) =>
                                                _chapter.id ==
                                                currentChapter.id);

                                        currentChapter = widget
                                            .listChapters![currentIndex + 1];
                                        videoPlayerController!
                                            .removeListener(startVideo);
                                        videoPlayerController!.dispose();
                                        startVideFirst();
                                      }
                                    },
                                    eventPreviusVideo: () {
                                      if (widget.listChapters != null &&
                                          widget.listChapters!.indexWhere(
                                                  (_chapter) =>
                                                      _chapter.id ==
                                                      currentChapter.id) >
                                              0) {
                                        videoPlayerController!.pause();
                                        int currentIndex = widget.listChapters!
                                            .indexWhere((_chapter) =>
                                                _chapter.id ==
                                                currentChapter.id);

                                        currentChapter = widget
                                            .listChapters![currentIndex - 1];

                                        videoPlayerController!
                                            .removeListener(startVideo);
                                        videoPlayerController!.dispose();
                                        startVideFirst();
                                      }
                                    },
                                    onClickSlider: onClickSlider,
                                    videoPlayerController:
                                        videoPlayerController,
                                    timerOpacity: timerOpacity,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: VideoBar(
                                    onChangeStart: (value) async {
                                      await videoPlayerController!.pause();
                                      setState(() {
                                        onClickSlider = true;
                                        Future.delayed(
                                            Duration(milliseconds: 300), () {
                                          onClickSlider = false;
                                        });
                                      });
                                    },
                                    onChanged: (value) async {
                                      setState(() {
                                        totalTimeVideoText = timeVideo(
                                            videoPlayerController!
                                                .value.duration);

                                        positionVideoText = timeVideo(
                                            videoPlayerController!
                                                .value.position);
                                        currentPosition = value.toInt();
                                        onClickSlider = false;
                                      });
                                      await videoPlayerController!.seekTo(
                                          Duration(seconds: value.toInt()));
                                    },
                                    onChangeEnd: (value) async {
                                      setState(() {
                                        onClickSlider = false;
                                      });
                                      await videoPlayerController!.play();
                                    },
                                    fullScreenVideo: fullScreenVideo,
                                    fullScreenEvent: () {
                                      fullScreenVideo = !fullScreenVideo;
                                      widget.eventFullScreen();
                                    },
                                    timerOpacity: timerOpacity,
                                    currentPosition: currentPosition,
                                    maxDurationVideo: maxDurationVideo,
                                    positionVideoText: positionVideoText,
                                    totalTimeVideoText: totalTimeVideoText,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container()),
              ),
              if (!fullScreenVideo) widget.viewQuiz,
            ],
          ),
        ),
      );
    });
  }
}
