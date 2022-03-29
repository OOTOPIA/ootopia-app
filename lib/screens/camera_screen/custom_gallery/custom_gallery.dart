import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/components/media_view_widget.dart';
import 'package:ootopia_app/screens/camera_screen/custom_gallery/custom_gallery_grid_view.dart';
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
  bool hasError = false;
  var singleMode = true;
  static const selectLimit = 5;
  static const limitMedias = 15;
  bool showToastMessage = false;

  int countPage = 0;
  bool hasMoreMedias = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    setState(() {
      isLoading = true;
    });
    getAlbum();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (hasMoreMedias) {
        Future.delayed(Duration.zero, () async {
          await getImageList(countPage);
        });
      }
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
          if (selectedMedias != []) {
            Navigator.of(this.context).pushNamed(
              PageRoute.Page.postPreviewScreen.route,
              arguments: {
                "fileList": selectedMedias,
                "mirrored": "false",
              },
            );
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
                        children: [
                          SizedBox(height: 20),
                          MediaViewWidget(
                            key: ObjectKey(currentDirectory["mediaFile"].path),
                            mediaFilePath: currentDirectory["mediaFile"].path,
                            mediaType: currentDirectory["mediaType"],
                            mediaSize: currentDirectory["mediaSize"],
                          ),
                          SizedBox(height: 10),
                          multipleImagesButton(),
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
                          if (isLoadingMoreMedia) CircularProgressIndicator(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
          showToastMessage ? ToastMessageWidget() : Container()
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

  handleMediaOnGridView(Map media) {
    return media["mediaType"] == 'video'
        ? media["mediaBytes"]
        : media["mediaFile"];
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
