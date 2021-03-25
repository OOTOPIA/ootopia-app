import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class PLayerVideoFullscreen extends StatefulWidget {
  Map<String, dynamic> args;

  PLayerVideoFullscreen({this.args});

  @override
  _PLayerVideoFullscreenState createState() => _PLayerVideoFullscreenState();
}

class _PLayerVideoFullscreenState extends State<PLayerVideoFullscreen> {
  FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    print("args aqui ${widget.args["url"]}");
    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(widget.args["url"]),
    );

    flickManager.flickControlManager.enterFullscreen();
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        preferredDeviceOrientationFullscreen: [
          flickManager.flickVideoManager.videoPlayerValue.size
              .width >
              flickManager.flickVideoManager.videoPlayerValue
                  .size.height
              ? DeviceOrientation.landscapeLeft
              : DeviceOrientation.portraitUp
        ],
          flickManager: flickManager,
      ),
    );
  }
}
