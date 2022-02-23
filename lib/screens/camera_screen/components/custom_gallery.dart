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
  var isLoading = false;
  var singleMode = true;
  static const selectLimit = 5;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAlbum();
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
        onTapAction: () => print('vish'),
      ),
      body: Stack(
        children: [
          BackgroundButterflyTop(positioned: -59),
          BackgroundButterflyBottom(),
          isLoading
              ? CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Container(
                        width: 360,
                        height: 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: FileImage(selectedMedias.last["mediaFile"]),
                            //MemoryImage(selectedMedias.last["mediaBytes"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
          //colocar um timing
          Positioned(
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
                    'The limit is 5 photos or videos',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

    selectedMedias.add(mediaList.first);

    setState(() {
      isLoading = false;
    });
  }

  // getImageList() async {
  //   _assetEntityList =
  //       await albums.first.getAssetListPaged(0, albums.first.assetCount);

  //   for (var teste in _assetEntityList) {
  //     testeFile = await teste.file;
  //     print(testeFile);
  //     mediaList.add({
  //       "mediaBytes": await teste.thumbDataWithSize(200, 200),
  //       "mediaType": teste.mimeType!.split('/')
  //     });
  //   }

  //   selectedMedias.add(mediaList.first);

  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  handleMediaOnGridView(Map media) {
    if (media["mediaType"] == 'video')
      return media["mediaBytes"];
    else
      return media["mediaFile"];
  }

  switchMode() {
    selectedMedias = [mediaList.first];
    setState(() {
      singleMode = !singleMode;
    });
  }

  void selectMedia(Map media) {
    if (singleMode) {
      selectedMedias.first = media;
    } else {
      handleMultipleMedia(media);
    }
    print(selectedMedias.length);
    setState(() {});
  }

  handleMultipleMedia(Map media) {
    var hasMedia = selectedMedias
        .singleWhereOrNull((element) => element["mediaId"] == media["mediaId"]);
    if (hasMedia == null) {
      if (selectedMedias.length < selectLimit)
        selectedMedias.add(media);
      else
        print('');
    } else {
      selectedMedias
          .removeWhere((element) => element["mediaId"] == media["mediaId"]);
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
