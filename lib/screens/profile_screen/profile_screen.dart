//Packages
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/page-enum.dart';
// import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:provider/provider.dart';

//Files
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/profile_screen/components/grid_custom_widget.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
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
  ProfileScreenStore? store;
  late AuthStore authStore;
  late WalletStore walletStore;
  late HomeStore homeStore;
  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  bool profileUserIsLoggedUser = true;
  String profileUserId = '';

  bool isVisible = false;
  SmartPageController controller = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();
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

  _goToTimelinePost(posts, postSelected) {
    controller.insertPage(
      TimelineScreenProfileScreen(
        {
          "userId": _getUserId(),
          "posts": posts,
          "postSelected": postSelected,
        },
      ),
    );
  }

  _goToWalletPage() {
    controller.selectBottomTab(3);
  }

  bool get isLoggedInUserProfile {
    return authStore.currentUser == null
        ? false
        : ((widget.args == null || widget.args!["id"] == null)
            ? true
            : widget.args!["id"] == authStore.currentUser!.id);
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
      body: Observer(
        builder: (_) => LoadingOverlay(
          isLoading: store?.loadingProfile == true,
          child: store?.profile == null
              ? Container(
                  height: MediaQuery.of(context).size.height,
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: GlobalConstants.of(context).spacingNormal,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AvatarPhotoWidget(
                            photoUrl: store?.profile!.photoUrl,
                            sizePhotoUrl: 114,
                            isBadges: store == null
                                ? false
                                : store!.profile!.badges!.length > 0,
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
                        height: GlobalConstants.of(context).intermediateSpacing,
                      ),
                      Text(
                        store == null ? "" : store!.profile!.fullname,
                        style: GoogleFonts.roboto(
                            color: Theme.of(context).textTheme.subtitle1!.color,
                            fontSize: 24,
                            fontWeight: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .fontWeight),
                      ),
                      SizedBox(
                          height: GlobalConstants.of(context).spacingNormal),
                      Text(
                        AppLocalizations.of(context)!
                            .regenerationGame
                            .toUpperCase(),
                        style: GoogleFonts.roboto(
                            color: Theme.of(context).textTheme.subtitle1!.color,
                            fontSize:
                                Theme.of(context).textTheme.subtitle1!.fontSize,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: GlobalConstants.of(context).spacingSmall),
                      Container(
                        height: 46,
                        width: MediaQuery.of(context).size.width * 0.8,
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
                                          .regenerationGame,
                                      text: AppLocalizations.of(context)!
                                          .theRegenerationGame,
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
                                    //text:
                                    //"${authStore.currentUser!.dailyLearningGoalInMinutes}m",
                                    text: "10m",
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
                                        "${store?.profile!.totalTrophyQuantity!}",
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
                                margin: EdgeInsets.only(
                                    bottom: GlobalConstants.of(context)
                                        .spacingNormal),
                                padding: EdgeInsets.symmetric(
                                    horizontal: GlobalConstants.of(context)
                                        .screenHorizontalSpace),
                                decoration: BoxDecoration(
                                    color: Color(0xff707070).withOpacity(.05)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: GamingDataWidget(
                                        title: AppLocalizations.of(context)!
                                            .personal,
                                        icon: FeatherIcons.user,
                                        amount: store == null
                                            ? 0
                                            : store!.profile!
                                                .personalTrophyQuantity!,
                                        colorIcon: Color(0xff00A5FC),
                                      ),
                                      onTap: () => showModalBottomSheet(
                                        context: context,
                                        barrierColor: Colors.black.withAlpha(1),
                                        backgroundColor:
                                            Colors.black.withAlpha(1),
                                        builder: (BuildContext context) {
                                          return SnackBarWidget(
                                              menu:
                                                  AppLocalizations.of(context)!
                                                      .medals,
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .medalsRepresentHowManyTimesAPersonHasReachedTheirGoalInTheRegenerationGame,
                                              about:
                                                  AppLocalizations.of(context)!
                                                      .learnMore,
                                              marginBottom: true);
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      child: GamingDataWidget(
                                        title:
                                            AppLocalizations.of(context)!.city,
                                        icon: FeatherIcons.mapPin,
                                        amount: store == null
                                            ? 0
                                            : store!
                                                .profile!.cityTrophyQuantity!,
                                        colorIcon: Color(0xff0072C5),
                                      ),
                                      onTap: () => showModalBottomSheet(
                                        context: context,
                                        barrierColor: Colors.black.withAlpha(1),
                                        backgroundColor:
                                            Colors.black.withAlpha(1),
                                        builder: (BuildContext context) {
                                          return SnackBarWidget(
                                              menu:
                                                  AppLocalizations.of(context)!
                                                      .medals,
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .medalsRepresentHowManyTimesAPersonHasReachedTheirGoalInTheRegenerationGame,
                                              about:
                                                  AppLocalizations.of(context)!
                                                      .learnMore,
                                              marginBottom: true);
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      child: GamingDataWidget(
                                        title: AppLocalizations.of(context)!
                                            .planetary,
                                        icon: FeatherIcons.globe,
                                        amount: store == null
                                            ? 0
                                            : store!
                                                .profile!.globalTrophyQuantity!,
                                        colorIcon: Color(0xff012588),
                                      ),
                                      onTap: () => showModalBottomSheet(
                                        context: context,
                                        barrierColor: Colors.black.withAlpha(1),
                                        backgroundColor:
                                            Colors.black.withAlpha(1),
                                        builder: (BuildContext context) {
                                          return SnackBarWidget(
                                              menu:
                                                  AppLocalizations.of(context)!
                                                      .medals,
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .medalsRepresentHowManyTimesAPersonHasReachedTheirGoalInTheRegenerationGame,
                                              about:
                                                  AppLocalizations.of(context)!
                                                      .learnMore,
                                              marginBottom: true);
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                            : SizedBox(),
                      ),
                      Visibility(
                        visible: store?.profile?.bio != null &&
                            store?.profile?.bio != '',
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GlobalConstants.of(context)
                                      .screenHorizontalSpace),
                              child: Text(
                                store?.profile!.bio != null
                                    ? store!.profile!.bio!
                                    : "",
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            )
                          ],
                        ),
                      ),
                      isLoggedInUserProfile
                          ? InkWell(
                              onTap: () {
                                _goToWalletPage();
                              },
                              child: Container(
                                width: double.maxFinite,
                                height: 60,
                                padding: EdgeInsets.symmetric(
                                    horizontal: GlobalConstants.of(context)
                                        .intermediateSpacing),
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
                      if (store != null && store!.postsList.length > 0)
                        SizedBox(
                          height: GlobalConstants.of(context).spacingNormal,
                        ),
                      if (store != null && store!.postsList.length > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: GlobalConstants.of(context)
                                      .screenHorizontalSpace -
                                  6),
                          child: Row(
                            children: [
                              AlbumProfileWidget(
                                onTap: () {},
                                albumName: AppLocalizations.of(context)!.all2,
                                photoAlbumUrl: "",
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      PageRoute.Page.newFutureCategories.route);
                                },
                                child: AlbumProfileWidget(
                                  onTap: () {},
                                  albumName:
                                      AppLocalizations.of(context)!.album,
                                ),
                              )
                            ],
                          ),
                        ),
                      if (store != null && store!.postsList.length > 0)
                        SizedBox(
                          height: GlobalConstants.of(context).spacingNormal,
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
                                crossAxisAlignment: WrapCrossAlignment.start,
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
                                            _goToTimelinePost(
                                                store!.postsList, index);
                                          },
                                        ),
                                      ),
                                    )
                                    .values
                                    .toList(),
                              ),
                            )
                          : EmptyPostsWidget(),
                      SizedBox(
                        height: GlobalConstants.of(context).intermediateSpacing,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
