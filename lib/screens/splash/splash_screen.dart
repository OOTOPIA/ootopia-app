import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class SplashScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  SplashScreen(
    this.args, {
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController? _videoPlayerController;
  bool videoIsFinished = false;

  @override
  void initState() {
    super.initState();
    _initController();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _videoPlayerController?.dispose();

      // Initing new controller
      _initController();
    });

    // Making sure that controller is not used by setting it to null
    setState(() {
      _videoPlayerController = null;
    });
  }

  _initController() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/ootopia_splash.mp4')
          ..initialize()
          ..setLooping(false)
          ..addListener(() {
            Timer(Duration(milliseconds: 300),
                () => _videoPlayerController?.play());

            if (mounted) {
              setState(() {
                if (_videoPlayerController?.value.isPlaying == false &&
                    _videoPlayerController?.value.isInitialized == true &&
                    (_videoPlayerController?.value.duration ==
                        _videoPlayerController?.value.position) &&
                    !videoIsFinished) {
                  videoIsFinished = true;
                  _videoPlayerController = null;
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
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            height: _videoPlayerController?.value.size.height,
            width: _videoPlayerController?.value.size.width,
            child: _videoPlayerController == null
                ? Container()
                : VideoPlayer(_videoPlayerController!),
          ),
        ),
      ),
    );
  }
}
