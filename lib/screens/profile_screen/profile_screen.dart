//Packages
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/data/models/friends/friend_model.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/edit_profile_screen/add_link/view_link_screen.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:ootopia_app/screens/friends/circle_friends_widget/circle_friends_widget.dart';
import 'package:ootopia_app/screens/friends/friends_store.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/profile_screen/components/location_profile_info_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_album_list_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_avatar_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_bio_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/wallet_bar_widget.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:provider/provider.dart';
import 'package:ootopia_app/screens/profile_screen/components/grid_custom_widget.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/empty_posts_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  ProfileScreen([this.args]);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenStore? store;
  late FriendsStore friendsStore;
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
        if (authStore.currentUser != null) {
          await store!.getIfIsFriend(profileUserId);
        } else {
          if (widget.args!.containsKey('isGetContacts')) {
            await authStore.checkUserIsLogged();
            await store!.getIfIsFriend(profileUserId);
          }
        }
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

  get appBarProfile => DefaultAppBar(
        components: [
          AppBarComponents.back,
          isLoggedInUserProfile
              ? AppBarComponents.edit
              : AppBarComponents.empty,
        ],
        onTapAction: () => isLoggedInUserProfile
            ? controller.insertPage(EditProfileScreen())
            : null,
        onTapLeading: () => widget.args!.containsKey('isGetContacts')
            ? Navigator.pop(context)
            : controller.back(),
      );

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
      // setState(() {
      if (store!.hasMorePosts && store!.loadingPosts == false) {
        Future.delayed(Duration.zero, () async {
          await store?.getUserPosts(profileUserId);
        });
      }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    walletStore = Provider.of<WalletStore>(context);
    homeStore = Provider.of<HomeStore>(context);
    if (profileUserIsLoggedUser) {
      store = Provider.of<ProfileScreenStore>(context);
    } else {
      friendsStore = Provider.of<FriendsStore>(context);
    }
    return Scaffold(
      appBar: showAppBar()
          ? appBarProfile
          : widget.args!.containsKey('isGetContacts')
              ? appBarProfile
              : null,
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                store == null ? "" : store!.profile!.fullname,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
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
                            ),
                            SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal),
                            ProfileBioWidget(bio: store?.profile?.bio),
                            if (store?.profile?.links != null) ...[
                              if (store!.profile!.links!.length == 1) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: GlobalConstants.of(context)
                                          .screenHorizontalSpace),
                                  child: TextButton(
                                    onPressed: () async {
                                      _launchURL(store!.profile!.links![0].URL);
                                    },
                                    child: Text(
                                      store!.profile!.links![0].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Color(0xff018F9C),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else if (store!.profile!.links!.length > 1) ...[
                                TextButton(
                                  onPressed: () {
                                    if (widget.args!
                                        .containsKey('isGetContacts')) {
                                      Navigator.pushNamed(context,
                                          PageRoute.Page.viewLinksScreen.route);
                                    } else {
                                      controller.insertPage(ViewLinksScreen(
                                        {
                                          'store': store,
                                          'user_id': 1,
                                          'list': store!.profile!.links!,
                                        },
                                      ));
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.relatedLinks,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: Color(0xff018F9C),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                SizedBox(
                                  height:
                                      GlobalConstants.of(context).spacingNormal,
                                )
                              ],
                            ],
                            if (showButton ||
                                (widget.args != null &&
                                    widget.args!
                                        .containsKey('isGetContacts'))) ...[
                              ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                        Size(double.infinity, 35)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide.none),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            LightColors.blue),
                                    padding: MaterialStateProperty.all<
                                            EdgeInsets>(
                                        EdgeInsets.symmetric(horizontal: 24)),
                                  ),
                                  onPressed: () {
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      final friend = FriendModel(
                                        id: store!.profile!.id,
                                        fullname: store!.profile!.fullname,
                                        photoUrl: store!.profile!.photoUrl,
                                      );

                                      if (store!.isFriend == false) {
                                        store!.addFriend();
                                        friendsStore.addFriend(friend);
                                      } else {
                                        store!.removeFriend();
                                        friendsStore.removeFriend(
                                            friend, authStore.currentUser!.id);
                                      }
                                    });
                                  },
                                  child: Text(
                                    store!.isFriend == false
                                        ? AppLocalizations.of(context)!
                                            .addFriend
                                        : AppLocalizations.of(context)!
                                            .removeFriend,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              SizedBox(
                                height: 16,
                              )
                            ],
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            LocationProfileInfoWidget(
                              isVisible: isVisible,
                              profileScreenStore: store,
                            ),
                            if (isLoggedInUserProfile) ...[
                              WalletBarWidget(
                                  totalBalance: walletStore.wallet != null
                                      ? '${currencyFormatter.format(walletStore.wallet!.totalBalance)}'
                                      : '0,00',
                                  onTap: () =>
                                      controller.insertPage(WalletPage())),
                            ],
                            CircleOfFriendWidget(
                              isUserLogged: isLoggedInUserProfile,
                              userId: store!.profile!.id,
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
                                          .map((index, post) {
                                            return MapEntry(
                                              index,
                                              GridCustomWidget(
                                                discountSpacing: 10 * 3,
                                                amountPadding: 0,
                                                thumbnailUrl:
                                                    post.type != 'gallery'
                                                        ? post.thumbnailUrl!
                                                        : post.medias != [] &&
                                                                post.medias!
                                                                    .isNotEmpty
                                                            ? post.medias!.first
                                                                .thumbUrl!
                                                            : '',
                                                columnsCount: 4,
                                                type: store!.getPostType(post),
                                                onTap: () {
                                                  store!.goToTimelinePost(
                                                    controller: controller,
                                                    userId: _getUserId(),
                                                    posts: store!.postsList,
                                                    postSelected: index,
                                                  );
                                                },
                                              ),
                                            );
                                          })
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
    if (await canLaunch(_url)) {
      await launch(_url);
    }
  }

  bool showAppBar() {
    return controller.currentBottomIndex ==
            PageViewController.TAB_INDEX_PROFILE &&
        (controller.pages[controller.currentPageIndex]) is ProfileScreen;
  }

  bool get showButton {
    return !isLoggedInUserProfile &&
        store?.isFriend != null &&
        authStore.currentUser != null;
  }
}
