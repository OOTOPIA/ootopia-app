import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class SplashScreen extends StatefulWidget {
  Map<String, dynamic>? args;

  SplashScreen(
    this.args, {
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoPlayerController;
  bool videoIsFinished = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(
        'assets/videos/ootopia_splash.mp4')
      ..initialize()
      ..addListener(() {
        Timer(Duration(milliseconds: 300), () => _videoPlayerController.play());

        if (mounted) {
          setState(() {
            if (!_videoPlayerController.value.isPlaying &&
                _videoPlayerController.value.isInitialized &&
                (_videoPlayerController.value.duration ==
                    _videoPlayerController.value.position) &&
                !videoIsFinished) {
              videoIsFinished = true;
              Navigator.of(context).pushReplacementNamed(
                PageRoute.Page.homeScreen.route,
              );
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: _videoPlayerController.value.size.height,
            width: _videoPlayerController.value.size.width,
            child: VideoPlayer(_videoPlayerController),
          ),
        ),
      ),
    );
  }
}
