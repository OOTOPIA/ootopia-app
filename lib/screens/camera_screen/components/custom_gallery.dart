import 'dart:async';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/camera_screen/components/custom_gallery_grid_view.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:video_player/video_player.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CustomGallery extends StatefulWidget {
  const CustomGallery({Key? key}) : super(key: key);

  @override
  _CustomGalleryState createState() => _CustomGalleryState();
}

class _CustomGalleryState extends State<CustomGallery> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> _assetEntityList = [];
  List<Map> mediaList = [];
  List<Map> selectedMedias = [];
  Map currentDirectory = {
    "mediaId": null,
    "mediaFile": null,
    "mediaType": null,
    "mediaBytes": null,
  };
  var isLoading = false;
  var singleMode = true;
  static const selectLimit = 5;
  bool showToastMessage = false;
  late VideoPlayerController? _videoPlayerController;
  bool videoIsLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAlbum();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.proceed,
        ],
        onTapLeading: () => Navigator.of(context).pop(),
        onTapAction: () {
          if (selectedMedias != [])
            Navigator.of(this.context).pushNamed(
              PageRoute.Page.postPreviewScreen.route,
              arguments: {
                "filePath": selectedMedias.first['mediaFile'].path,
                "mirrored": "false",
                "type": "image"
              },
            );
        },
      ),
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      if (currentDirectory["mediaType"] != 'video')
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            //width: 360,
                            height: 360,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: FileImage(currentDirectory["mediaFile"]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        if (videoIsLoading == true)
                          CircularProgressIndicator()
                        else ...[
                          Container(
                            width: 360,
                            height: 360,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: FlickVideoPlayer(
                                flickManager: FlickManager(
                                  videoPlayerController:
                                      _videoPlayerController!,
                                ),
                              ),
                            ),
                          )
                        ],
                      ],
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              GlobalConstants.of(context).screenHorizontalSpace,
                        ),
                        child: GestureDetector(
                          onTap: switchMode,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.multiplesImages,
                                style: GoogleFonts.roboto(
                                    color: LightColors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 2),
                              SvgPicture.asset(
                                'assets/icons/multiples_images.svg',
                                height: 18,
                                width: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: GlobalConstants.of(context)
                                  .screenHorizontalSpace -
                              5,
                        ),
                        width: double.infinity,
                        child: Center(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 8, // gap between adjacent chips
                            runSpacing: 8, // gap between lines
                            children: mediaList
                                .asMap()
                                .map(
                                  (index, media) => MapEntry(
                                    index,
                                    CustomGalleryGridView(
                                      discountSpacing: 10 * 3,
                                      amountPadding: 0,
                                      media: handleMediaOnGridView(media),
                                      mediaType: media["mediaType"],
                                      columnsCount: 3,
                                      singleMode: singleMode,
                                      positionOnList: returnPosition(media),
                                      onTap: () => selectMedia(media),
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
          showToastMessage
              ? Positioned(
                  bottom: 20,
                  left: GlobalConstants.of(context).screenHorizontalSpace + 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 55,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: LightColors.cyan,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 15),
                        SvgPicture.asset(
                          'assets/icons/Icon-feather-check.svg',
                          height: 18,
                          width: 18,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          AppLocalizations.of(context)!.limitSelectedImages,
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> getAlbum() async {
    Future.delayed(Duration.zero, () async {
      albums = await PhotoManager.getAssetPathList(onlyAll: true);
      getImageList();
    });
  }

  getImageList() async {
    _assetEntityList =
        await albums.first.getAssetListPaged(0, albums.first.assetCount);

    for (var assetEntity in _assetEntityList) {
      mediaList.add({
        "mediaId": assetEntity.hashCode,
        "mediaFile": await assetEntity.file,
        "mediaType": assetEntity.mimeType!.split('/').first,
        "mediaBytes": await assetEntity.thumbDataWithSize(200, 200),
      });
    }

    selectedMedias = [mediaList.first];
    initialMedia(mediaList.first);

    setState(() {
      isLoading = false;
    });
  }

  handleMediaOnGridView(Map media) {
    if (media["mediaType"] == 'video')
      return media["mediaBytes"];
    else
      return media["mediaFile"];
  }

  switchMode() {
    initialMedia(mediaList.first);
    setState(() {
      singleMode = !singleMode;
    });
  }

  void selectMedia(Map media) {
    if (singleMode) {
      selectedMedias = [media];
    } else {
      handleMultipleMedia(media);
    }

    initialMedia(selectedMedias.last);
    setState(() {});
  }

  handleMultipleMedia(Map media) {
    var hasMedia = selectedMedias
        .singleWhereOrNull((element) => element["mediaId"] == media["mediaId"]);

    if (hasMedia == null && selectedMedias.length < selectLimit) {
      selectedMedias.add(media);
    } else if (hasMedia == null && selectedMedias.length >= selectLimit) {
      showToastMessage = true;
      Future.delayed(Duration(seconds: 3), () async {
        showToastMessage = false;
        setState(() {});
      });
    } else {
      selectedMedias
          .removeWhere((element) => element["mediaId"] == media["mediaId"]);
      if (selectedMedias.length == 0) initialMedia(mediaList.first);
    }
  }

  initialMedia(Map selectedMedia) {
    if (selectedMedia['mediaType'] == 'video' &&
        (currentDirectory['mediaId'] == null ||
            selectedMedia['mediaId'] != currentDirectory['mediaId'])) {
      _videoPlayerController = null;
      currentDirectory = selectedMedia;
      initVideoPlayer(currentDirectory['mediaFile']);
    } else if (selectedMedia['mediaType'] == 'image' &&
        (currentDirectory['mediaId'] == null ||
            selectedMedia['mediaId'] != currentDirectory['mediaId'])) {
      _videoPlayerController = null;
      currentDirectory = selectedMedia;
    }
  }

  returnPosition(Map media) {
    if (singleMode == false) {
      return (selectedMedias.indexWhere(
              (element) => element["mediaId"] == media["mediaId"])) +
          1;
    }
  }

  initVideoPlayer(var file) {
    videoIsLoading = true;
    _videoPlayerController = VideoPlayerController.file(file)
      ..initialize().then((value) {
        setState(() {
          videoIsLoading = false;
        });
        _videoPlayerController!.play();
      });
  }
}
