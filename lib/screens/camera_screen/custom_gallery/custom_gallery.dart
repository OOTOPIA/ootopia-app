import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/custom_image.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/toast_message_widget.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:visibility_detector/visibility_detector.dart';

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
    "mediaSize": null
  };

  bool isLoading = false;
  bool videoIsLoading = true;
  bool isLoadingMoreMedia = false;
  bool isReloadingMoreMedia = false;
  bool hasError = false;
  bool showImageTop = true;
  var singleMode = true;
  static const selectLimit = 5;
  static const limitMedias = 30;
  bool showToastMessageImageLimit = false;
  bool showToastMessageNoImage = false;

  int countPage = 0;
  bool hasMoreMedias = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollControllerMedias = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _scrollControllerMedias.addListener(_scrollListenerMedias);
    setState(() {
      isLoading = true;
    });
    getAlbum();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollControllerMedias.removeListener(_scrollListenerMedias);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        hasMoreMedias &&
        !isLoadingMoreMedia) {
      Future.delayed(Duration.zero, () async {
        await getImageList(countPage);
      });
    }
  }

  void _scrollListenerMedias() {
    if (_scrollControllerMedias.offset >=
            _scrollControllerMedias.position.maxScrollExtent &&
        !_scrollControllerMedias.position.outOfRange &&
        hasMoreMedias &&
        !isLoadingMoreMedia) {
      Future.delayed(Duration.zero, () async {
        await getImageList(countPage);
      });
    }
    if (_scrollControllerMedias.position.userScrollDirection ==
            ScrollDirection.forward &&
        _scrollControllerMedias.offset <= 5) {
      _scrollControllerMedias.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }
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
          if (selectedMedias.isNotEmpty) {
            Navigator.of(this.context).pushNamed(
              PageRoute.Page.postPreviewScreen.route,
              arguments: {
                "fileList": selectedMedias,
                "mirrored": "false",
              },
            );
          } else {
            showToastMessageNoImage = true;
            setState(() {});
            Future.delayed(Duration(seconds: 3), () async {
              showToastMessageNoImage = false;
              setState(() {});
            });
          }
        },
      ),
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : hasError
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)!.hasntImageOnGallery,
                        style: GoogleFonts.roboto(
                          color: LightColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        key: Key('Column'),
                        children: [
                          VisibilityDetector(
                            key: Key('Column'),
                            onVisibilityChanged: (visibilityInfo) {
                              if (visibilityInfo.visibleFraction <= 0.05) {
                                showImageTop = false;
                                setState(() {});
                              } else if (visibilityInfo.visibleFraction >= 0 &&
                                  showImageTop == false) {
                                showImageTop = true;
                                setState(() {});
                              }
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  MediaViewWidget(
                                    key: ObjectKey(
                                        currentDirectory["mediaFile"].path),
                                    mediaFilePath:
                                        currentDirectory["mediaFile"].path,
                                    mediaType: currentDirectory["mediaType"],
                                    mediaSize: currentDirectory["mediaSize"],
                                  ),
                                  SizedBox(height: 10),
                                  multipleImagesButton(),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: GridView.builder(
                              controller: _scrollControllerMedias,
                              physics: showImageTop
                                  ? NeverScrollableScrollPhysics()
                                  : null,
                              primary: false,
                              padding: EdgeInsets.symmetric(
                                  horizontal: GlobalConstants.of(context)
                                          .screenHorizontalSpace -
                                      10,
                                  vertical: showImageTop ? 0 : 50),
                              itemCount: mediaList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return CustomImage(
                                  media: mediaList[index]["mediaBytes"],
                                  mediaType: mediaList[index]["mediaType"],
                                  singleMode: singleMode,
                                  positionOnList:
                                      returnPosition(mediaList[index]),
                                  onTap: () => selectMedia(mediaList[index]),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 150,
                                childAspectRatio: 2 / 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                            ),
                          ),
                          if (isLoadingMoreMedia) CircularProgressIndicator(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
          showToastMessageNoImage
              ? ToastMessageWidget(
                  toastText: AppLocalizations.of(context)!.selectSomeImage,
                )
              : Container(),
          showToastMessageImageLimit
              ? ToastMessageWidget(
                  toastText: AppLocalizations.of(context)!.limitSelectedImages,
                )
              : Container()
        ],
      ),
    );
  }

  Widget multipleImagesButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GlobalConstants.of(context).screenHorizontalSpace,
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
                fontWeight: FontWeight.w500,
              ),
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
    );
  }

  Future<void> getAlbum() async {
    Future.delayed(Duration.zero, () async {
      albums = await PhotoManager.getAssetPathList(onlyAll: true);
      initializeImageList();
    });
  }

  initializeImageList() async {
    await getImageList(countPage);

    selectedMedias = [mediaList.first];
    initialMedia(mediaList.first);

    setState(() {
      isLoading = false;
    });
  }

  getImageList(int page) async {
    int initialPage = page * limitMedias;
    isLoadingMoreMedia = true;
    setState(() {});

    try {
      _assetEntityList = await albums.first.getAssetListRange(
          start: initialPage, end: initialPage + limitMedias);
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    for (var assetEntity in _assetEntityList) {
      mediaList.add({
        "mediaId": assetEntity.hashCode,
        "mediaFile": await assetEntity.file,
        "mediaType": assetEntity.type == AssetType.image ? 'image' : 'video',
        "mediaBytes": await assetEntity.thumbDataWithSize(200, 200),
        "mediaSize": assetEntity.size,
      });
    }

    hasMoreMedias = _assetEntityList.length == limitMedias;
    countPage++;
    isLoadingMoreMedia = false;
    setState(() {});
  }

  switchMode() {
    selectedMedias = [mediaList.first];
    initialMedia(mediaList.first);
    setState(() {
      singleMode = !singleMode;
    });
  }

  void selectMedia(Map media) {
    singleMode ? selectedMedias = [media] : handleMultipleMedia(media);

    if (selectedMedias.isNotEmpty) initialMedia(selectedMedias.last);
    setState(() {});
  }

  handleMultipleMedia(Map media) {
    var hasMedia = selectedMedias
        .singleWhereOrNull((element) => element["mediaId"] == media["mediaId"]);

    if (hasMedia == null && selectedMedias.length < selectLimit) {
      selectedMedias.add(media);
    } else if (hasMedia == null && selectedMedias.length >= selectLimit) {
      showToastMessageImageLimit = true;
      Future.delayed(Duration(seconds: 3), () async {
        showToastMessageImageLimit = false;
        setState(() {});
      });
    } else {
      selectedMedias.removeWhere(
        (element) => element["mediaId"] == media["mediaId"],
      );
      if (selectedMedias.isEmpty) {
        initialMedia(mediaList.first);
      }
    }
  }

  initialMedia(Map selectedMedia) {
    if (selectedMedia['mediaType'] == 'video' &&
        (currentDirectory['mediaId'] == null ||
            selectedMedia['mediaId'] != currentDirectory['mediaId'])) {
      currentDirectory = selectedMedia;
    } else if (selectedMedia['mediaType'] == 'image' &&
        (currentDirectory['mediaId'] == null ||
            selectedMedia['mediaId'] != currentDirectory['mediaId'])) {
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
}
