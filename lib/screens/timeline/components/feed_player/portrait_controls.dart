import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:provider/provider.dart';
import './multi_manager/flick_multi_manager.dart';

class FeedPlayerPortraitControls extends StatelessWidget with SecureStoreMixin {
  FeedPlayerPortraitControls({
    Key? key,
    required this.flickMultiManager,
    required this.flickManager,
    required this.url,
  }) : super(key: key);

  final FlickMultiManager flickMultiManager;
  final FlickManager flickManager;
  final String url;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
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
              toggleMute: () {
                flickMultiManager.toggleMute();
                if (flickManager.flickControlManager!.isMute) {
                  setTimelineVideosMuted();
                } else {
                  setTimelineVideosUnmuted();
                }
                displayManager.handleShowPlayerControls();
              },
              child: FlickSeekVideoAction(
                child: Center(child: FlickVideoBuffer()),
              ),
            ),
          ),
          FlickAutoHideChild(
            autoHide: true,
            showIfVideoNotInitialized: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlickSoundToggle(
                    toggleMute: () {
                      flickMultiManager.toggleMute();
                      if (flickManager.flickControlManager!.isMute) {
                        setTimelineVideosMuted();
                      } else {
                        setTimelineVideosUnmuted();
                      }
                    },
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  tooltip: 'Increase volume by 10',
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        PageRoute.Page.playerVideoFullScreen.route,
                        arguments: {"url": url});
                  },
                ),
                // FlickFullScreenToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
