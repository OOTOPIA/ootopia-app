import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:provider/provider.dart';
import './multi_manager/flick_multi_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedPlayerPortraitControls extends StatelessWidget with SecureStoreMixin {
  FeedPlayerPortraitControls({
    Key? key,
    required this.flickMultiManager,
    required this.flickManager,
    required this.url,
    this.onDoubleTap,
  }) : super(key: key);

  final FlickMultiManager flickMultiManager;
  final FlickManager flickManager;
  final String url;
  final Function? onDoubleTap;

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
            child: Container(
              child: GestureDetector(
                onTap: () {
                  flickManager.flickDisplayManager!.handleVideoTap();
                  print("tapped one time!!");
                },
                onDoubleTap: () {
                  if (this.onDoubleTap != null) {
                    this.onDoubleTap!();
                  }
                },
              ),
            ),
          ),
          FlickAutoHideChild(
            autoHide: true,
            showIfVideoNotInitialized: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
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
                  padding: EdgeInsets.only(left: 20),
                  constraints: BoxConstraints(),
                  icon: const Icon(Icons.fullscreen),
                  tooltip: AppLocalizations.of(context)!.increaseVolumeBy10,
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
