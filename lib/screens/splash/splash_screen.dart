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

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.asset('assets/videos/ootopia_splash.mp4')
          ..initialize().then((value) {
            _videoPlayerController.play();
            _videoPlayerController.addListener(() {
              setState(() {
                if (!_videoPlayerController.value.isPlaying &&
                    _videoPlayerController.value.isInitialized &&
                    (_videoPlayerController.value.duration ==
                        _videoPlayerController.value.position)) {
                  Navigator.of(context).pushReplacementNamed(
                    PageRoute.Page.timelineScreen.route,
                  );
                }
              });
            });
          });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
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
