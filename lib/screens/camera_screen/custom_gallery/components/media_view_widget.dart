import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:video_player/video_player.dart';

class MediaViewWidget extends StatefulWidget {
  final String mediaFilePath;
  final String mediaType;
  final Size? mediaSize;
  const MediaViewWidget(
      {Key? key,
      required this.mediaFilePath,
      required this.mediaType,
      this.mediaSize})
      : super(key: key);

  @override
  State<MediaViewWidget> createState() => _MediaViewWidgetState();
}

class _MediaViewWidgetState extends State<MediaViewWidget> {
  FlickManager? flickManager;
  bool videoIsLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == 'video') initVideo();
  }

  initVideo() {
    setState(() {
      videoIsLoading = true;
    });
    VideoPlayerController _videoPlayerController =
        VideoPlayerController.file(File(widget.mediaFilePath))
          ..initialize().then((value) {
            setState(() {
              videoIsLoading = false;
            });
          });

    flickManager = FlickManager(videoPlayerController: _videoPlayerController);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.mediaType == "video"
              ? MediaQuery.of(context).size.height * .6
              : MediaQuery.of(context).size.width +
                  GlobalConstants.of(context).spacingNormal * 2,
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: GlobalConstants.of(context).spacingNormal,
                right: GlobalConstants.of(context).spacingNormal,
                top: GlobalConstants.of(context).spacingNormal,
                bottom: GlobalConstants.of(context).screenHorizontalSpace,
              ),
              child: widget.mediaType == "video"
                  ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(21)),
                      child: videoIsLoading
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : FlickVideoPlayer(
                              preferredDeviceOrientationFullscreen: [],
                              flickManager: flickManager!,
                              flickVideoWithControls: FlickVideoWithControls(
                                controls: null,
                              ),
                            ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xff000000),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          fit:
                              widget.mediaSize!.height > widget.mediaSize!.width
                                  ? BoxFit.fitHeight
                                  : BoxFit.fitWidth,
                          alignment: FractionalOffset.center,
                          image: FileImage(File(widget.mediaFilePath)),
                        ),
                      ),
                    ),
            ),
            widget.mediaType == "video"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(
                            GlobalConstants.of(context).spacingMedium),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              flickManager!.flickControlManager!.isMute
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  //flickMultiManager.toggleMute();
                                  if (!flickManager!
                                      .flickControlManager!.isMute) {
                                    flickManager!.flickControlManager!.mute();
                                  } else {
                                    flickManager!.flickControlManager!.unmute();
                                  }
                                },
                              );
                            },
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}