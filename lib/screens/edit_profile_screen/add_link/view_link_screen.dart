import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ootopia_app/data/models/learning_tracks/learning_tracks_model.dart';
import 'package:ootopia_app/data/models/marketplace/product_model.dart';
import 'package:ootopia_app/data/models/users/link_model.dart';
import 'package:ootopia_app/data/repositories/learning_tracks_repository.dart';
import 'package:ootopia_app/data/repositories/marketplace_repository.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/learning_tracks/view_learning_tracks/view_learning_tracks.dart';
import 'package:ootopia_app/screens/marketplace/product_detail_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/avatar_photo_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ViewLinksScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  late final ProfileScreenStore store;
  late final List<Link> links;
  ViewLinksScreen(this.args) {
    store = args['store'];
    links = args['list'];
  }

  @override
  _ViewLinksScreenState createState() => _ViewLinksScreenState();
}

class _ViewLinksScreenState extends State<ViewLinksScreen> {
  SmartPageController controller = SmartPageController.getInstance();
  LearningTracksRepositoryImpl learningTracksStore =
      LearningTracksRepositoryImpl();
  MarketplaceRepositoryImpl marketplaceRepository = MarketplaceRepositoryImpl();
  get appBarProfile => DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.empty,
        ],
        onTapLeading: () => Navigator.pop(context),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.args.containsKey('displayContacts') ? appBarProfile : null,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: GlobalConstants.of(context).spacingNormal,
                  ),
                  AvatarPhotoWidget(
                    photoUrl: widget.store.profile!.photoUrl,
                    sizePhotoUrl: 114,
                  ),
                  SizedBox(height: GlobalConstants.of(context).spacingSmall),
                  Text(
                    widget.store.profile!.fullname,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).textTheme.subtitle1!.color,
                        fontSize: 24,
                        fontWeight:
                            Theme.of(context).textTheme.subtitle1!.fontWeight),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.links.length,
                    itemBuilder: (context, index) {
                      return urlItem(widget.links[index]);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget urlItem(Link link) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: LightColors.grey.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Ink(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            onTap: () {
              _launchURL(link.URL);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  if (link.URL.contains("market-place/shared/"))
                    Image.asset(
                      "assets/icons/marketplace_icon_bottomless.png",
                      width: 24,
                    ),
                  if (link.URL.contains("learning-tracks/shared/"))
                    SvgPicture.asset(
                      "assets/icons/compass.svg",
                      width: 24,
                      color: LightColors.blue,
                    ),
                  if (!link.URL.contains("market-place/shared/") &&
                      !link.URL.contains("learning-tracks/shared/"))
                    SvgPicture.asset('assets/icons/link.svg'),
                  SizedBox(width: 12),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 100),
                    child: Text(
                      link.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 20,
                          color: LightColors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    if (_url.contains("market-place/shared/")) {
      ProductModel productModel = await marketplaceRepository
          .getProductById(_url.split('market-place/shared/').last);
      if (widget.args.containsKey('displayContacts')) {
        Navigator.pushNamed(
          context,
          PageRoute.Page.productDetails.route,
          arguments: {
            'productModel': productModel,
            'displayContacts': true,
          },
        );
      } else {
        controller.insertPage(ProductDetailScreen(productModel: productModel));
      }
      return;
    }
    if (_url.contains("learning-tracks/shared/")) {
      LearningTracksModel learningTrack = await learningTracksStore
          .getLearningTrackById(_url.split('learning-tracks/shared/').last);
      if (widget.args.containsKey('displayContacts')) {
        Navigator.pushNamed(
          context,
          PageRoute.Page.viewLearningTracksScreen.route,
          arguments: {
            'displayContacts': true,
            'list_chapters': learningTrack.chapters,
            'learning_tracks': learningTrack,
            'updateLearningTrack': () {},
          },
        );
      } else {
        controller.insertPage(ViewLearningTracksScreen(
          {
            'list_chapters': learningTrack.chapters,
            'learning_tracks': learningTrack,
            'updateLearningTrack': () {},
          },
        ));
      }
      return;
    }
    if (await canLaunch(_url)) {
      await launch(_url);
    }
  }
}
