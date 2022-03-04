import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:video_player/video_player.dart';

class MediaViewWidget extends StatefulWidget {
  final File mediaFilePath;
  final String mediatype;
  final Size mediaSize;
  final VideoPlayerController? videoPlayerController;
  final bool? videoIsLoading;
  const MediaViewWidget({
    Key? key,
    required this.mediaFilePath,
    required this.mediatype,
    required this.mediaSize,
    this.videoPlayerController,
    this.videoIsLoading,
  }) : super(key: key);

  @override
  State<MediaViewWidget> createState() => _MediaViewWidgetState();
}

class _MediaViewWidgetState extends State<MediaViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.mediatype == "video"
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
              child: widget.mediatype == "video"
                  ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(21)),
                      child: widget.videoIsLoading!
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : FlickVideoPlayer(
                              flickManager: FlickManager(
                                videoPlayerController:
                                    widget.videoPlayerController!,
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
                          fit: widget.mediaSize.height > widget.mediaSize.width
                              ? BoxFit.fitHeight
                              : BoxFit.fitWidth,
                          alignment: FractionalOffset.center,
                          image: FileImage(widget.mediaFilePath),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
