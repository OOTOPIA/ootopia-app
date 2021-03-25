import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:provider/provider.dart';
import './multi_manager/flick_multi_manager.dart';

class FeedPlayerPortraitControls extends StatelessWidget {
  const FeedPlayerPortraitControls(
      {Key key, this.flickMultiManager, this.flickManager})
      : super(key: key);

  final FlickMultiManager flickMultiManager;
  final FlickManager flickManager;

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
            child: Container(),
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
                    FlickFullScreenToggle(
                      size: 30,
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
