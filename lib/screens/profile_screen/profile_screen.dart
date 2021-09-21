//Packages
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/page-enum.dart';
// import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';

//Files
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/profile_screen/components/grid_custom_widget.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'components/album_profile_widget.dart';
import 'components/avatar_photo_widget.dart';
import 'components/empty_posts_widget.dart';
import 'components/gaming_data_widget.dart';
import 'components/timeline_profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ProfileScreen extends StatefulWidget {
  Map<String, dynamic>? args;

  ProfileScreen([this.args]);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileScreenStore store;
  late AuthStore authStore;
  late WalletStore walletStore;
  late HomeStore homeStore;
  // AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await store.getProfileDetails(_getUserId());
      await homeStore.getCurrentUser(_getUserId());
      await store.getUserPosts(_getUserId());
      Future.delayed(Duration.zero, () {
        walletStore.getWallet();
      });
    });

    // this.trackingEvents.profileViewedAProfile(
    //   widget.args == null || (widget.args != null && widget.args!["id"] == null)
    //       ? AppLocalizations.of(context)!.profileOwnProfile
    //       : AppLocalizations.of(context)!.profileViewedAProfile,
    //   {"profileId": store.profile!.id},
    // );
  }

  String _getUserId() {
    if (widget.args == null || widget.args!["id"] == null) {
      return authStore.currentUser!.id!;
    } else {
      return widget.args!["id"];
    }
  }

  _goToTimelinePost(posts, postSelected) {
    PageViewController.instance.addPage(TimelineScreenProfileScreen(
      {
        "userId": _getUserId(),
        "posts": posts,
        "postSelected": postSelected,
      },
    ));
  }

  bool get isLoggedInUserProfile {
    return authStore.currentUser == null
        ? false
        : ((widget.args == null || widget.args!["id"] == null)
            ? true
            : widget.args!["id"] == authStore.currentUser!.id);
  }

  _goToPage(int index) {
    PageViewController.instance.goToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    walletStore = Provider.of<WalletStore>(context);
    homeStore = Provider.of<HomeStore>(context);
    store = Provider.of<ProfileScreenStore>(context);
    return Scaffold(
      body: Observer(
        builder: (_) => LoadingOverlay(
          isLoading: store.loadingProfile,
          child: store.profile == null
              ? Container()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AvatarPhotoWidget(
                            photoUrl: store.profile!.photoUrl,
                            isBadges: store.profile!.badges!.length > 0,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                barrierColor: Colors.black.withAlpha(1),
                                backgroundColor: Colors.black.withAlpha(1),
                                builder: (BuildContext context) {
                                  return SnackBarWidget(
                                    menu: AppLocalizations.of(context)!
                                        .changeMakerPro,
                                    text: AppLocalizations.of(context)!
                                        .theChangeMakerPro,
                                    about:
                                        AppLocalizations.of(context)!.learnMore,
                                    marginBottom: true,
                                    contact: {
                                      "text": AppLocalizations.of(context)!
                                          .areYouASowerToo,
                                      "textLink": AppLocalizations.of(context)!
                                          .getInContact,
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: GlobalConstants.of(context).spacingMedium,
                      ),
                      Text(
                        store.profile!.fullname,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height: GlobalConstants.of(context).spacingNormal),
                      Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width * .8,
                        decoration: BoxDecoration(
                            border: Border.fromBorderSide(BorderSide(
                                width: 1,
                                color: Color(0xff101010).withOpacity(.1))),
                            borderRadius: BorderRadius.circular(45)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  barrierColor: Colors.black.withAlpha(1),
                                  backgroundColor: Colors.black.withAlpha(1),
                                  builder: (BuildContext context) {
                                    return SnackBarWidget(
                                      menu: AppLocalizations.of(context)!
                                          .badgeSower,
                                      text: AppLocalizations.of(context)!
                                          .theSowerBadgeIsAwardedToIndividualsAndOrganizationsThatAreLeadingConsistentWorkToHelpRegeneratePlanetEarth,
                                      about: AppLocalizations.of(context)!
                                          .learnMore,
                                      marginBottom: true,
                                    );
                                  },
                                );
                              },
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                            .personalGoal +
                                        ": ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                  TextSpan(
                                    text:
                                        "${authStore.currentUser!.dailyLearningGoalInMinutes}m",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("|",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (isVisible) {
                                    isVisible = false;
                                  } else {
                                    isVisible = true;
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons_profile/teste.svg",
                                    width: 19,
                                    height: 16,
                                    color: Color(0xff00A5FC),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2),
                                    child: Text(
                                        "${store.profile!.totalTrophyQuantity!}",
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff00A5FC),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  RotationTransition(
                                    turns: !isVisible
                                        ? AlwaysStoppedAnimation(270 / 360)
                                        : AlwaysStoppedAnimation(90 / 360),
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Color(0xff03145C),
                                      size: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: GlobalConstants.of(context).spacingNormal,
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child: isVisible
                            ? Container(
                                width: double.maxFinite,
                                height: 54,
                                padding: EdgeInsets.symmetric(
                                    horizontal: GlobalConstants.of(context)
                                        .screenHorizontalSpace),
                                decoration: BoxDecoration(
                                    color: Color(0xff707070).withOpacity(.05)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GamingDataWidget(
                                      title: AppLocalizations.of(context)!
                                          .personal,
                                      icon: FeatherIcons.user,
                                      amount: store
                                          .profile!.personalTrophyQuantity!,
                                      colorIcon: Color(0xff00A5FC),
                                    ),
                                    GamingDataWidget(
                                      title: AppLocalizations.of(context)!.city,
                                      icon: FeatherIcons.mapPin,
                                      amount:
                                          store.profile!.cityTrophyQuantity!,
                                      colorIcon: Color(0xff0072C5),
                                    ),
                                    GamingDataWidget(
                                      title: AppLocalizations.of(context)!
                                          .planetary,
                                      icon: FeatherIcons.globe,
                                      amount:
                                          store.profile!.globalTrophyQuantity!,
                                      colorIcon: Color(0xff012588),
                                    ),
                                  ],
                                ))
                            : SizedBox(),
                      ),
                      SizedBox(
                        height: GlobalConstants.of(context).spacingNormal,
                      ),
                      store.profile!.bio != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GlobalConstants.of(context)
                                      .screenHorizontalSpace),
                              child: Text(
                                store.profile!.bio != null
                                    ? store.profile!.bio!
                                    : "",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : SizedBox(),
                      store.profile!.bio != null
                          ? SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            )
                          : SizedBox(),
                      isLoggedInUserProfile
                          ? InkWell(
                              onTap: () {
                                _goToPage(PageViewController.TAB_INDEX_WALLET);
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: 60,
                                padding: EdgeInsets.symmetric(
                                    horizontal: GlobalConstants.of(context)
                                        .screenHorizontalSpace),
                                decoration: BoxDecoration(
                                    color: Color(0xff707070).withOpacity(.05)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/ooz-coin-black.png",
                                          width: 22,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .wallet,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .currentOOZBalance,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff707070),
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icons/ooz_only_active.png",
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  walletStore.wallet != null
                                                      ? '${walletStore.wallet!.totalBalance.toString().length > 6 ? NumberFormat.compact().format(walletStore.wallet?.totalBalance).replaceAll('.', ',') : walletStore.wallet?.totalBalance.toStringAsFixed(2).replaceAll('.', ',')}'
                                                      : '0,00',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Color(0xff003694),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Color(0xff03145C),
                                            size: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: GlobalConstants.of(context).spacingNormal,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GlobalConstants.of(context)
                                .screenHorizontalSpace),
                        child: Divider(
                          height: 1,
                          color: Color(0xff707070).withOpacity(.5),
                        ),
                      ),
                      if (store.postsList.length > 0)
                        SizedBox(
                          height: GlobalConstants.of(context).spacingNormal,
                        ),
                      if (store.postsList.length > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: GlobalConstants.of(context)
                                      .screenHorizontalSpace -
                                  6),
                          child: Row(
                            children: [
                              AlbumProfileWidget(
                                onTap: () {},
                                albumName: "Passeio",
                                photoAlbumUrl: "hello",
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      PageRoute.Page.newFutureCategories.route);
                                },
                                child: AlbumProfileWidget(
                                  onTap: () {},
                                  albumName: "Album",
                                ),
                              )
                            ],
                          ),
                        ),
                      if (store.postsList.length > 0)
                        SizedBox(
                          height: GlobalConstants.of(context).spacingNormal,
                        ),
                      if (store.postsList.length > 0)
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
                      store.postsList.length > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GlobalConstants.of(context)
                                          .screenHorizontalSpace -
                                      5), // compensating for the internal spacing of each item
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: store.postsList
                                    .asMap()
                                    .map(
                                      (index, post) => MapEntry(
                                        index,
                                        GridCustomWidget(
                                          thumbnailUrl: post.thumbnailUrl,
                                          columnsCount: 4,
                                          type: post.type,
                                          onTap: () {
                                            _goToTimelinePost(
                                                store.postsList, index);
                                          },
                                        ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ),
                            )
                          : EmptyPostsWidget(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
