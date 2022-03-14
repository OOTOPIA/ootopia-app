import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/custom_controls.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/custom_crop.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MediaViewWidget extends StatefulWidget {
  final String mediaFilePath;
  final String mediaType;
  final Size? mediaSize;
  final bool shouldCustomFlickManager;
  final bool showCropWidget;
  final ValueChanged<File>? onChanged;
  const MediaViewWidget({
    Key? key,
    required this.mediaFilePath,
    required this.mediaType,
    this.mediaSize,
    this.shouldCustomFlickManager = false,
    this.showCropWidget = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<MediaViewWidget> createState() => _MediaViewWidgetState();
}

class _MediaViewWidgetState extends State<MediaViewWidget> {
  bool isLoading = false;
  FlickManager? flickManager;
  VideoPlayerController? _videoPlayerController;
  bool controlIsVisible = true;
  File? croppedImage;

  @override
  void initState() {
    super.initState();
    if (widget.mediaType == "video") {
      initFlickManager();
    }
  }

  initFlickManager() {
    isLoading = true;

    _videoPlayerController =
        VideoPlayerController.file(File(widget.mediaFilePath))
          ..initialize().then((value) {
            setState(() {
              isLoading = false;
            });
            _videoPlayerController!.setLooping(true);
            flickManager =
                FlickManager(videoPlayerController: _videoPlayerController!);
          });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    flickManager?.dispose();
    super.dispose();
  }

  @mustCallSuper
  @protected
  void didUpdateWidget(covariant MediaViewWidget oldWidget) {
    if (oldWidget.mediaType == "video")
      flickManager?.flickControlManager!.pause();

    if (widget.mediaType == "video") initFlickManager();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (_) => flickManager?.flickControlManager!.pause(),
      child: Container(
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
                        child: isLoading
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
                                  controls: widget.shouldCustomFlickManager
                                      ? CustomControls(
                                          flickManager: flickManager!,
                                        )
                                      : FlickPortraitControls(),
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
                            fit: widget.mediaSize!.height >
                                    widget.mediaSize!.width
                                ? BoxFit.fitHeight
                                : BoxFit.fitWidth,
                            alignment: FractionalOffset.center,
                            image: croppedImage != null
                                ? FileImage(
                                    File(croppedImage!.path),
                                  )
                                : FileImage(
                                    File(widget.mediaFilePath),
                                  ),
                          ),
                        ),
                      ),
              ),
              widget.mediaType == "image" && widget.showCropWidget
                  ? Positioned(
                      right: 30,
                      bottom: 35,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomCrop(
                              image: File(widget.mediaFilePath),
                              onChanged: (value) {
                                setState(() {
                                  croppedImage = value;
                                  widget.onChanged!(croppedImage!);
                                });
                              },
                            ),
                          ),
                        ),
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/crop.svg',
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
