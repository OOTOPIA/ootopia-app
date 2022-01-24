//Packages
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/edit_profile_screen/add_link/view_link_screen.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/location_profile_info_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_album_list_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_avatar_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_bio_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/regenerative_game_details.dart';
import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:provider/provider.dart';
import 'package:ootopia_app/screens/profile_screen/components/grid_custom_widget.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/empty_posts_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  ProfileScreen([this.args]);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenStore? store;
  late AuthStore authStore;
  late WalletStore walletStore;
  late HomeStore homeStore;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  bool profileUserIsLoggedUser = true;
  String profileUserId = '';

  bool isVisible = false;
  SmartPageController controller = SmartPageController.getInstance();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    if (store != null && profileUserIsLoggedUser) {
      store!.profile = null;
    }
    Future.delayed(Duration.zero, () async {
      profileUserId = _getUserId();

      if (store != null && profileUserIsLoggedUser) {
        store!.profile = null;
      }

      if (!profileUserIsLoggedUser) {
        store = ProfileScreenStore();
      }

      await store?.getProfileDetails(profileUserId);
      await homeStore.getCurrentUser(profileUserId);
      await store?.getUserPosts(profileUserId);

      Future.delayed(Duration.zero, () {
        if (profileUserIsLoggedUser) walletStore.getWallet();
      });

      this.trackingEvents.profileViewedAProfile(
        widget.args == null ||
                (widget.args != null && widget.args!["id"] == null)
            ? AppLocalizations.of(context)!.profileOwnProfile
            : AppLocalizations.of(context)!.profileViewedAProfile,
        {
          "profileId": store?.profile!.id,
        },
      );
    });
  }

  String _getUserId() {
    if (widget.args == null || widget.args!["id"] == null) {
      setState(() {
        profileUserIsLoggedUser = true;
      });
      return authStore.currentUser!.id!;
    } else {
      setState(() {
        profileUserIsLoggedUser =
            authStore.currentUser?.id == widget.args!["id"];
      });
      return widget.args!["id"];
    }
  }

  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  bool get isLoggedInUserProfile {
    return authStore.currentUser == null
        ? false
        : ((widget.args == null || widget.args!["id"] == null)
            ? true
            : widget.args!["id"] == authStore.currentUser!.id);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (store!.hasMorePosts && store!.loadingPosts == false) {
          Future.delayed(Duration.zero, () async {
            await store?.getUserPosts(profileUserId);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    walletStore = Provider.of<WalletStore>(context);
    homeStore = Provider.of<HomeStore>(context);
    if (profileUserIsLoggedUser) {
      store = Provider.of<ProfileScreenStore>(context);
    }
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            BackgroundButterflyTop(positioned: -59),
            BackgroundButterflyBottom(positioned: -50),
            Observer(
              builder: (_) => LoadingOverlay(
                isLoading: store?.loadingProfile == true,
                child: store?.profile == null
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            ProfileAvatarWidget(profileScreenStore: store),
                            SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingSmall),
                            Text(
                              store == null ? "" : store!.profile!.fullname,
                              style: GoogleFonts.roboto(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .color,
                                  fontSize: 24,
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontWeight),
                            ),
                            SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal),
                            ProfileBioWidget(bio: store?.profile?.bio),


                            if(store?.profile?.links != null)...[
                                if(store!.profile!.links!.length == 1)...[
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: GlobalConstants.of(context).screenHorizontalSpace),                                    child: TextButton(
                                      onPressed: () async{
                                        _launchURL(store!.profile!.links![0].URL);
                                      },
                                      child: Text(store!.profile!.links![0].title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: Color(0xff018F9C),
                                        ),),
                                    ),
                                  ),
                                ]else if (store!.profile!.links!.length > 1)...[
                                  TextButton(
                                    onPressed: (){
                                      controller.insertPage(ViewLinksScreen(
                                        {
                                          'store': store,
                                          'user_id': 1,
                                          'list': store!.profile!.links!,
                                        },
                                      ));

                                    },
                                    child: Text(AppLocalizations.of(context)!.relatedLinks,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Color(0xff018F9C),
                                      ),),
                                  ),
                                ]else...[
                                  SizedBox(
                                    height: GlobalConstants.of(context).spacingNormal,
                                  )
                                ],
                            ],

                            Text(
                              AppLocalizations.of(context)!
                                  .regenerationGame
                                  .toUpperCase(),
                              style: GoogleFonts.roboto(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .color,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontSize,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            RegenerativeGameDetails(
                              isVisible: isVisible,
                              onArrowTap: () {
                                setState(() {
                                  if (isVisible) {
                                    isVisible = false;
                                  } else {
                                    isVisible = true;
                                  }
                                });
                              },
                            ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            LocationProfileInfoWidget(
                              isVisible: isVisible,
                              profileScreenStore: store,
                            ),
                            isLoggedInUserProfile
                                ? WalletBarWidget(
                                    totalBalance: walletStore.wallet != null
                                        ? '${currencyFormatter.format(walletStore.wallet!.totalBalance)}'
                                        : '0,00',
                                    onTap: () =>
                                        controller.insertPage(WalletPage()))
                                : Container(),
                            SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GlobalConstants.of(context)
                                      .screenHorizontalSpace),
                              child: Divider(
                                height: 1,
                                color: Color(0xff707070).withOpacity(.5),
                              ),
                            ),
                            if (store != null && store!.postsList.length > 0)
                              SizedBox(
                                  height: GlobalConstants.of(context)
                                      .spacingNormal),
                            if (store != null && store!.postsList.length > 0)
                              ProfileAlbumListWidget(),
                            if (store != null && store!.postsList.length > 0)
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal,
                              ),
                            if (store != null && store!.postsList.length > 0)
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: GlobalConstants.of(context)
                                        .screenHorizontalSpace),
                                child: Divider(
                                  height: 1,
                                  color: Color(0xff707070).withOpacity(.5),
                                ),
                              ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            store != null && store!.postsList.length > 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: GlobalConstants.of(context)
                                                .screenHorizontalSpace -
                                            5), // compensating for the internal spacing of each item
                                    width: double.infinity,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      spacing: 10, // gap between adjacent chips
                                      runSpacing: 20, // gap between lines
                                      children: store!.postsList
                                          .asMap()
                                          .map(
                                            (index, post) => MapEntry(
                                              index,
                                              GridCustomWidget(
                                                discountSpacing: 10 * 3,
                                                amountPadding: 0,
                                                thumbnailUrl: post.thumbnailUrl,
                                                columnsCount: 4,
                                                type: post.type,
                                                onTap: () {
                                                  store!.goToTimelinePost(
                                                    controller: controller,
                                                    userId: _getUserId(),
                                                    posts: store!.postsList,
                                                    postSelected: index,
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                          .values
                                          .toList(),
                                    ),
                                  )
                                : EmptyPostsWidget(),
                            Observer(
                                builder: (_) => (store!.loadingPosts &&
                                        store!.hasMorePosts)
                                    ? SizedBox(
                                        width: double.infinity,
                                        height: 90,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Container()),
                            SizedBox(
                                height: GlobalConstants.of(context)
                                    .intermediateSpacing),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    if(await canLaunch(_url)){
      await launch(_url);
    }
  }


}
