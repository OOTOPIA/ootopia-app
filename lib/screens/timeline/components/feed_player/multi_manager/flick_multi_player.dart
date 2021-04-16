import 'package:flutter/services.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/portrait_controls.dart';

import './flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class FlickMultiPlayer extends StatefulWidget {
  const FlickMultiPlayer({
    Key key,
    this.url,
    this.image,
    this.flickMultiManager,
  }) : super(key: key);

  final String url;
  final String image;
  final FlickMultiManager flickMultiManager;

  @override
  _FlickMultiPlayerState createState() => _FlickMultiPlayerState();
}

class _FlickMultiPlayerState extends State<FlickMultiPlayer> {
  FlickManager flickManager;
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    startPlayerController();
  }

  void startPlayerController() {
    videoPlayerController = VideoPlayerController.network(widget.url);

    flickManager = FlickManager(
      videoPlayerController: videoPlayerController..setLooping(true),
      autoPlay: false,
    );

    widget.flickMultiManager.init(flickManager);
  }

  @override
  void dispose() {
    widget.flickMultiManager.remove(flickManager);
    flickManager.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visiblityInfo) {
        if (visiblityInfo.visibleFraction > 0.9) {
          widget.flickMultiManager.play(flickManager);
        }
      },
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .6),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FlickVideoPlayer(
            preferredDeviceOrientationFullscreen: [
              flickManager.flickVideoManager.videoPlayerValue.size.width >
                      flickManager
                          .flickVideoManager.videoPlayerValue.size.height
                  ? DeviceOrientation.landscapeLeft
                  : DeviceOrientation.portraitUp
            ],
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              playerLoadingFallback: Positioned.fill(
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              controls: FeedPlayerPortraitControls(
                  flickMultiManager: widget.flickMultiManager,
                  flickManager: flickManager,
                  url: widget.url),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              videoFit: BoxFit.contain,
              playerLoadingFallback: Center(
                  child: Image.network(
                widget.image,
                fit: BoxFit.fitWidth,
              )),
              controls: FlickLandscapeControls(),
              iconThemeData: IconThemeData(
                size: 40,
                color: Colors.white,
              ),
              textStyle: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
