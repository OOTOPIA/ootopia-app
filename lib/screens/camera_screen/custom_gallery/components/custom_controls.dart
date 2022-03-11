import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';

class CustomControls extends StatelessWidget {
  CustomControls({
    Key? key,
    required this.flickManager,
  }) : super(key: key);

  final FlickManager flickManager;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        flickManager.flickDisplayManager!.handleVideoTap();
        print("tapped one time!!");
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Stack(
          children: <Widget>[
            FlickAutoHideChild(
              showIfVideoNotInitialized: false,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  height: 60,
                  child: FlickPlayToggle(
                    color: Colors.white,
                    size: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: FlickAutoHideChild(
                autoHide: true,
                showIfVideoNotInitialized: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FlickSoundToggle(
                        toggleMute: () {
                          flickManager.flickControlManager!.toggleMute();
                        },
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
