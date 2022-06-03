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
import 'package:ootopia_app/screens/friends/suggestion_friends/suggestion_friends_widget.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/profile_screen/components/avatar_photo_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/language_understood_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/location_profile_info_widget.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_album_list_widget.dart';
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

  @override
  void dispose() {
    store!.cleanPage();
    super.dispose();
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
        onTapLeading: () =>
            widget.args != null && widget.args!.containsKey('isGetContacts')
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

  void showModalProfile() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            content: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.removeUser,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                    text: ' ${store!.profile!.fullname} ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                TextSpan(
                  text: AppLocalizations.of(context)!.permanently,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )
              ]),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.cancel.toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )),
              TextButton(
                  onPressed: () async {
                    await authStore.deleteUser(profileUserId);
                    Navigator.pop(context);

                    if (authStore.deletedUser) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(
                          GlobalConstants.of(context).spacingNormal,
                        ),
                        backgroundColor: Color(0xff03DAC5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        content: Row(
                          children: [
                            Icon(Icons.done, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.userDeleted,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ));
                      controller.back();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          margin: EdgeInsets.all(
                            GlobalConstants.of(context).spacingNormal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.red,
                          content: Text(
                            AppLocalizations.of(context)!
                                .somethingWentWrongInDeleteUser,
                            style: TextStyle(color: Colors.white),
                          )));
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ))
            ],
          );
        });
  }

  void _selectedOption(String optionSelected) {
    if (optionSelected == 'delete') {
      showModalProfile();
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
          : widget.args != null && widget.args!.containsKey('isGetContacts')
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            Stack(
                              children: [
                                AvatarPhotoWidget(
                                  photoUrl: store?.profile!.photoUrl,
                                  sizePhotoUrl: 114,
                                ),
                                if (authStore.currentUser!.isAdmin != null &&
                                    authStore.currentUser!.isAdmin!)
                                  //&& authStore.currentUser!.id != profileUserId)
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: PopupMenuButton<String>(
                                      padding: EdgeInsets.zero,
                                      offset: Offset(-25, 36),
                                      onSelected: _selectedOption,
                                      enabled: true,
                                      icon: Icon(Icons.more_vert),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Row(children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .remove,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              ' ${store!.profile!.fullname}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
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
                                      Navigator.pushNamed(
                                        context,
                                        PageRoute.Page.viewLinksScreen.route,
                                        arguments: {
                                          'displayContacts': true,
                                          'store': store,
                                          'user_id': 1,
                                          'list': store!.profile!.links!,
                                        },
                                      );
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
                                  child: Observer(builder: (context) {
                                    return Text(
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
                                    );
                                  })),
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
                            if (store!.profile?.languages?.isNotEmpty == true)
                              LanguageUnderstoodWidget(
                                languages: store!.profile?.languages,
                              ),
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
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
                              displayContacts: widget.args != null &&
                                  widget.args!.containsKey('isGetContacts'),
                              isUserLogged: isLoggedInUserProfile,
                              userId: store!.profile!.id,
                            ),
                            if (profileUserIsLoggedUser &&
                                isLoggedInUserProfile) ...[
                              SuggestionFriends(
                                friendsStore:
                                    Provider.of<FriendsStore>(context),
                                userId: store!.profile!.id,
                              ),
                            ],
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GlobalConstants.of(context)
                                      .screenHorizontalSpace),
                              child: Divider(
                                height: 1,
                                color: Color(0xff707070).withOpacity(.5),
                              ),
                            ),
                            if (store != null &&
                                store!.postsList.isNotEmpty) ...[
                              SizedBox(
                                  height: GlobalConstants.of(context)
                                      .spacingNormal),
                              ProfileAlbumListWidget(),
                              SizedBox(
                                height:
                                    GlobalConstants.of(context).spacingNormal,
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
                            ],
                            SizedBox(
                              height: GlobalConstants.of(context).spacingNormal,
                            ),
                            if (store != null &&
                                store!.postsList.isNotEmpty) ...[
                              Container(
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
                                      .map((index, post) {
                                        return MapEntry(
                                          index,
                                          GridCustomWidget(
                                            discountSpacing: 10 * 3,
                                            amountPadding: 0,
                                            thumbnailUrl: post.type != 'gallery'
                                                ? post.thumbnailUrl!
                                                : post.medias != [] &&
                                                        post.medias!.isNotEmpty
                                                    ? post
                                                        .medias!.first.thumbUrl!
                                                    : '',
                                            columnsCount: 4,
                                            type: store!.getPostType(post),
                                            onTap: () {
                                              if (widget.args != null &&
                                                  widget.args!.containsKey(
                                                      'isGetContacts')) {
                                                Navigator.pushNamed(
                                                    context,
                                                    PageRoute
                                                        .Page
                                                        .timelineProfileScreen
                                                        .route,
                                                    arguments: {
                                                      "displayContacts": true,
                                                      "userId": _getUserId(),
                                                      "posts": store!.postsList,
                                                      "postSelected": index,
                                                    });
                                              } else {
                                                store!.goToTimelinePost(
                                                  controller: controller,
                                                  userId: _getUserId(),
                                                  posts: store!.postsList,
                                                  postSelected: index,
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      })
                                      .values
                                      .toList(),
                                ),
                              )
                            ] else ...[
                              EmptyPostsWidget()
                            ],
                            if (store!.loadingPosts && store!.hasMorePosts) ...[
                              SizedBox(
                                width: double.infinity,
                                height: 90,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            ],
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
    return !isLoggedInUserProfile && authStore.currentUser != null;
  }
}
