import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/multi_manager/flick_multi_manager.dart';
import 'package:ootopia_app/screens/timeline/components/feed_player/portrait_controls.dart';
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
  VideoPlayerController videoPlayer;
  bool isPortrait = true;

  @override
  void initState() {
    super.initState();

    videoPlayer = VideoPlayerController.network(widget.args["url"]);
    videoPlayer
      ..addListener(() {
        isPortrait =
            videoPlayer.value.size.width < videoPlayer.value.size.height;
        if (videoPlayer.value.size.width > 0 && !isPortrait) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.landscapeLeft]);
        }
      })
      ..setLooping(true);

    flickManager = FlickManager(
      videoPlayerController: videoPlayer,
    );

    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    flickManager.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlickVideoPlayer(
          preferredDeviceOrientationFullscreen: [],
          flickManager: flickManager,
          flickVideoWithControls:
              FlickVideoWithControls(controls: PlayerControls()),
        ),
      ),
    );
  }
}

class PlayerControls extends StatelessWidget {
  const PlayerControls(
      {Key key, this.flickMultiManager, this.flickManager, this.url})
      : super(key: key);

  final FlickMultiManager flickMultiManager;
  final FlickManager flickManager;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlickLeftDuration(),
              ),
            ),
          ),
          Expanded(
            child: FlickToggleSoundAction(
              toggleMute: () {},
              child: FlickSeekVideoAction(
                child: Center(child: FlickVideoBuffer()),
              ),
            ),
          ),
          FlickAutoHideChild(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    FlickPlayToggle(size: 30),
                    SizedBox(
                      width: 10,
                    ),
                    FlickSoundToggle(size: 30),
                    SizedBox(
                      width: 20,
                    ),
                    DefaultTextStyle(
                      style: TextStyle(color: Colors.white54),
                      child: Row(
                        children: <Widget>[
                          FlickCurrentPosition(
                            fontSize: 16,
                          ),
                          Text('/'),
                          FlickTotalDuration(
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    FlickAutoHideChild(
                      autoHide: false,
                      showIfVideoNotInitialized: false,
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen),
                        tooltip: 'Increase volume by 10',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
