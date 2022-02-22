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

class CustomGallery extends StatefulWidget {
  const CustomGallery({Key? key}) : super(key: key);

  @override
  _CustomGalleryState createState() => _CustomGalleryState();
}

class _CustomGalleryState extends State<CustomGallery> {
  List<AssetPathEntity> albums = [];
  List<AssetEntity> _mediaList = [];
  List imageList = [];
  var isLoading = false;

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
        onTapLeading: () => print('vish2'),
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
                            image: MemoryImage(imageList.first),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: GlobalConstants.of(context)
                                .screenHorizontalSpace),
                        child: GestureDetector(
                          onTap: () => print('Teste'),
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
                            children: imageList
                                .asMap()
                                .map(
                                  (index, imageBytes) => MapEntry(
                                    index,
                                    CustomGalleryGridView(
                                      discountSpacing: 10 * 3,
                                      amountPadding: 0,
                                      image: imageBytes,
                                      columnsCount: 3,
                                    ),
                                  ),
                                )
                                .values
                                .toList(),
                          ),
                        ),
                      ),
                    ],
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
    _mediaList =
        await albums.first.getAssetListPaged(0, albums.first.assetCount);

    for (var teste in _mediaList) {
      imageList.add(await teste.thumbDataWithSize(200, 200));
    }
    setState(() {
      isLoading = false;
    });
  }
}
