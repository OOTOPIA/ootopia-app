//Packages
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ootopia_app/screens/wallet/wallet_store.dart';
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

class ProfileScreen extends StatefulWidget {
  Map<String, dynamic>? args;

  ProfileScreen([this.args]);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileScreenStore store = ProfileScreenStore();
  late AuthStore authStore;
  late WalletStore walletStore;

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await store.getProfileDetails(_getUserId());

      await store.getUserPosts(_getUserId());
      Future.delayed(Duration.zero, () {
        walletStore.getWallet();
      });
    });
  }

  String _getUserId() {
    if (widget.args == null || widget.args!["id"] == null) {
      return authStore.currentUser!.id!;
    } else {
      return widget.args!["id"];
    }
  }

  _goToTimelinePost(posts, postSelected) {
    print("Meu log aqui $posts, $postSelected");
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
                            border: Border.fromBorderSide(
                                BorderSide(width: 1, color: Color(0xff707070))),
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
                                    child: Text("23",
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
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
                              AlbumProfileWidget(
                                onTap: () {},
                                albumName: "Album",
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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ootopia_app/bloc/user/user_bloc.dart';
// import 'package:ootopia_app/bloc/wallet/wallet_bloc.dart';
// import 'package:ootopia_app/data/models/users/profile_model.dart';
// import 'package:ootopia_app/data/models/timeline/timeline_post_model.dart';
// import 'package:ootopia_app/data/models/users/user_model.dart';
// import 'package:ootopia_app/data/models/wallets/wallet_transfer_group_model.dart';
// import 'package:ootopia_app/data/models/wallets/wallet_transfer_model.dart';
// import 'package:ootopia_app/data/models/wallets/wallet_model.dart';
// import 'package:ootopia_app/data/repositories/post_repository.dart';
// import 'package:ootopia_app/data/repositories/user_repository.dart';
// import 'package:ootopia_app/data/repositories/wallet_repository.dart';
// import 'package:ootopia_app/screens/components/try_again.dart';
// import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
// import 'package:ootopia_app/screens/profile_screen/components/timeline_profile.dart';
// import 'package:ootopia_app/screens/profile_screen/components/wallet_transfer_history.dart';
// import 'package:ootopia_app/screens/profile_screen/skeleton_profile_screen.dart';
// import 'package:ootopia_app/shared/distribution_system.dart';
// import 'package:ootopia_app/shared/global-constants.dart';
// import 'package:ootopia_app/shared/snackbar_component.dart';
// import 'package:ootopia_app/shared/secure-store-mixin.dart';
// import '../../data/models/users/badges_model.dart';
// import '../components/menu_drawer.dart';
// import '../../shared/analytics.server.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
// import 'package:package_info/package_info.dart';
// import "package:collection/collection.dart";
// import 'package:intl/intl.dart';

// class ProfileScreen extends StatefulWidget {
//   Map<String, dynamic>? args;

//   ProfileScreen([this.args]);

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen>
//     with SecureStoreMixin, TickerProviderStateMixin, WidgetsBindingObserver {
//   late UserBloc profileBloc;
//   UserRepositoryImpl profileRepositoryImpl = UserRepositoryImpl();
//   WalletRepositoryImpl walletRepositoryImpl = WalletRepositoryImpl();
//   PostRepositoryImpl postRepositoryImpl = PostRepositoryImpl();
//   AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
//   late WalletBloc walletBloc;

//   bool loggedIn = false;
//   late User user;
//   Profile? userProfile;
//   late Wallet wallet;
//   List<WalletTransferGroup> allWalletTransfers = [];
//   List<WalletTransferGroup> receivedWalletTransfers = [];
//   List<WalletTransferGroup> sentWalletTransfers = [];
//   bool loadingPosts = true;
//   bool loadPostsError = false;
//   bool loadingMorePosts = false;
//   bool loadingWallet = true;
//   bool loadingTransactions = true;
//   bool loadWalletError = false;
//   List<TimelinePost> posts = [];
//   int _postsPerPageCount = 12;
//   int _walletTransferPerPageCount = 12;
//   bool _hasMorePosts = true;
//   int currentPage = 1;
//   int walletTransferCurrentPage = 1;
//   int walletTransferReceivedCurrentPage = 1;
//   int walletTransferSentCurrentPage = 1;
//   int tabIndexSelected = 0;
//   String userId = "";
//   late String appVersion;
//   late TabController _tabController;
//   late TabController _tabControllerTransactions;
//   int _activeTabIndex = 0;
//   int _activeTabIndexTransactions = 0;

//   @override
//   void initState() {
//     _tabController = new TabController(length: 2, vsync: this);
//     WidgetsBinding.instance!.addPostFrameCallback((_) {
//       _checkUserIsLoggedIn();
//       profileBloc = BlocProvider.of<UserBloc>(context);
//       walletBloc = BlocProvider.of<WalletBloc>(context);
//       getAppInfo();
//       _tabController.addListener(_setActiveTabIndex);
//       _tabControllerTransactions = new TabController(length: 3, vsync: this);
//       _tabControllerTransactions.addListener(_setActiveTabIndexTransactions);
//       this.trackingEvents.profileViewedAProfile(
//         widget.args == null ||
//                 (widget.args != null && widget.args!["id"] == null)
//             ? AppLocalizations.of(context)!.profileOwnProfile
//             : AppLocalizations.of(context)!.profileViewedAProfile,
//         {"profileId": userId},
//       );
//     });
//     super.initState();
//   }

//   void _setActiveTabIndex() {
//     setState(() {
//       _activeTabIndex = _tabController.index;
//     });
//   }

//   void _setActiveTabIndexTransactions() {
//     setState(() {
//       _activeTabIndexTransactions = _tabControllerTransactions.index;
//     });
//   }

//   @override
//   void deactivate() {
//     OOzDistributionSystem.getInstance().endTimelineView("deactivate profile");
//     super.deactivate();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     // These are the callbacks
//     print("Lifecycle ===> $state");
//     switch (state) {
//       case AppLifecycleState.resumed:
//         OOzDistributionSystem.getInstance().endTimelineView("resumed profile");

//         // widget is resumed
//         break;
//       case AppLifecycleState.inactive:
//         OOzDistributionSystem.getInstance().endTimelineView("inactive profile");

//         // widget is inactive
//         break;
//       case AppLifecycleState.paused:
//         OOzDistributionSystem.getInstance().endTimelineView("paused profile");

//         // widget is paused
//         break;
//       case AppLifecycleState.detached:
//         OOzDistributionSystem.getInstance().endTimelineView("detached profile");

//         // widget is detached
//         break;
//     }
//   }

//   Future<void> getAppInfo() async {
//     final PackageInfo info = await PackageInfo.fromPlatform();
//     setState(() {
//       this.appVersion = info.version;
//     });
//   }

//   void _checkUserIsLoggedIn() async {
//     loggedIn = await getUserIsLoggedIn();
//     if (widget.args == null || widget.args!["id"] == null) {
//       user = await getCurrentUser();
//       print("Meu ID ${user.id}");
//       userId = user.id!;
//     } else {
//       userId = widget.args!["id"];
//     }
//     _performAllRequests();
//   }

//   void _performAllRequests() {
//     this.posts = [];
//     currentPage = 1;
//     walletTransferCurrentPage = 1;
//     walletTransferReceivedCurrentPage = 1;
//     walletTransferSentCurrentPage = 1;
//     getUserProfile(userId);
//     getUserPosts();
//     getUserWallet();
//     getUserTransactionHistory();
//   }

//   Future getUserProfile(String id) async {
//     this.profileRepositoryImpl.getProfile(id).then((user) {
//       setState(() {
//         userProfile = user;
//       });
//     });
//   }

//   Future getUserPosts() async {
//     setState(() {
//       if (this.posts.length > 0) {
//         loadingMorePosts = true;
//       } else {
//         loadingPosts = true;
//       }
//     });
//     this
//         .postRepositoryImpl
//         .getPosts(
//           _postsPerPageCount,
//           (currentPage - 1) * _postsPerPageCount,
//           userId,
//         )
//         .then((posts) {
//       setState(() {
//         loadingPosts = false;
//         loadingMorePosts = false;
//         _hasMorePosts = posts.length == _postsPerPageCount;
//         this.posts.addAll(posts.where((post) =>
//             post.userId == userId &&
//             this.posts.where((p) => p.id == post.id).length == 0));
//       });
//     }).catchError((onError) {
//       setState(() {
//         loadingPosts = false;
//         loadingMorePosts = false;
//         loadPostsError = true;
//       });
//     });
//   }

//   Future getUserWallet() async {
//     setState(() {
//       loadingWallet = true;
//     });
//     this.walletRepositoryImpl.getWallet(userId).then((wallet) {
//       this.wallet = wallet;
//       setState(() {
//         loadingWallet = false;
//       });
//     }).catchError((onError) {
//       setState(() {
//         loadingWallet = false;
//         loadWalletError = true;
//       });
//     });
//   }

//   Future getUserTransactionHistory([String? param]) async {
//     setState(() {
//       loadingTransactions = true;
//     });
//     int currentPage;

//     if (param != null && param == "received") {
//       currentPage = walletTransferReceivedCurrentPage;
//     } else if (param != null && param == "sent") {
//       currentPage = walletTransferSentCurrentPage;
//     } else {
//       currentPage = walletTransferCurrentPage;
//     }

//     this
//         .walletRepositoryImpl
//         .getTransactionHistory(_walletTransferPerPageCount,
//             (currentPage - 1) * _walletTransferPerPageCount, param)
//         .then((resultTransactions) {
//       groupBy(
//           resultTransactions,
//           (WalletTransfer obj) => DateFormat('dd-MM-yyyy')
//               .format(DateTime.parse(obj.createdAt))
//               .toString()).entries.toList().forEach((entry) {
//         if (param != null && param == "received") {
//           this.receivedWalletTransfers.add(
//                 WalletTransferGroup(
//                   date: entry.key,
//                   transfers: entry.value
//                       .where((obj) => obj.action == "received")
//                       .toList(),
//                 ),
//               );
//         } else if (param != null && param == "sent") {
//           this.sentWalletTransfers.add(
//                 WalletTransferGroup(
//                   date: entry.key,
//                   transfers:
//                       entry.value.where((obj) => obj.action == "sent").toList(),
//                 ),
//               );
//         } else {
//           this.allWalletTransfers.add(
//               WalletTransferGroup(date: entry.key, transfers: entry.value));
//         }
//       });

//       setState(() {
//         loadingTransactions = false;
//       });
//     }).catchError((onError) {
//       print("error 1 --> ${onError.toString()}");
//       setState(() {
//         loadingTransactions = false;
//         // loadWalletError = true;
//       });
//     });
//   }

//   Future<void> _loadMorePosts() async {
//     getUserPosts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: userProfile != null
//             ? Text(
//                 userProfile!.fullname,
//                 style: TextStyle(color: Colors.black),
//               )
//             : Text(''),
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color(0xffC0D9E8),
//                 Color(0xffffffff),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           setState(() {
//             _performAllRequests();
//             currentPage = 1;
//             loadingMorePosts = false;
//           });
//         },
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: SingleChildScrollView(
//             child: Container(
//               // this will set the outer container size to the height of your screen
//               height: MediaQuery.of(context).size.height +
//                   (30 * (posts.length > 4 ? posts.length / 4 : 1)),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Avatar(
//                         photoUrl:
//                             userProfile == null ? null : userProfile!.photoUrl,
//                         badges: userProfile!.badges,
//                         modal: "profile",
//                       ),
//                       DataProfile(),
//                     ],
//                   ),
//                   (userProfile != null && userProfile!.bio != null)
//                       ? Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                           child: RichText(
//                             textAlign: TextAlign.left,
//                             text:
//                                 (userProfile != null && userProfile!.bio != null
//                                     ? TextSpan(
//                                         text: ('Bio: '),
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black87,
//                                           fontSize: 16,
//                                         ),
//                                         children: <TextSpan>[
//                                           TextSpan(
//                                             text: userProfile!.bio,
//                                             style: TextStyle(
//                                               color: Colors.black87,
//                                               fontWeight: FontWeight.normal,
//                                             ),
//                                           )
//                                         ],
//                                       )
//                                     : TextSpan(text: "")),
//                           ),
//                         )
//                       : SizedBox.shrink(),
//                   Padding(
//                     padding: EdgeInsets.only(top: 6),
//                     child: Container(
//                       child: TabBar(
//                         controller: _tabController,
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         indicatorColor: Colors.transparent,
//                         tabs: [
//                           TabItem(
//                             backgroundColor: Color(0xff598006),
//                             iconAssetPath: 'assets/icons/add.png',
//                             borderBottomColor: Color(0xffbbd784),
//                             text: AppLocalizations.of(context)!.posts,
//                             isActiveTab: _activeTabIndex == 0,
//                           ),
//                           TabItem(
//                             backgroundColor: Color(0xfffc0499),
//                             iconAssetPath: 'assets/icons/ootopia.png',
//                             borderBottomColor: Color(0xfff074be),
//                             text: "OOZ ${AppLocalizations.of(context)!.wallet}",
//                             isActiveTab: _activeTabIndex == 1,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _postsTabView(), // É aqui
//                         _walletTabView(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   _postsTabView() {
//     if (loadingPosts) {
//       return SkeletonProfileScreen();
//     }
//     if (loadPostsError) {
//       return Center(
//         child: Text(AppLocalizations.of(context)!.errorOnGetPosts),
//       );
//     }
//     return Column(
//       children: [
//         GridPosts(
//             context: context,
//             userId: userId,
//             posts: posts,
//             getPostCallback: getUserPosts),
//         Visibility(
//           visible: posts.length >= _postsPerPageCount && _hasMorePosts,
//           child: loadingMorePosts
//               ? Center(child: CircularProgressIndicator())
//               : ButtonTheme(
//                   height: 48,
//                   child: FlatButton(
//                     child: Padding(
//                       padding: EdgeInsets.all(
//                         GlobalConstants.of(context).spacingSmall,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Icon(Icons.expand_more_rounded,
//                                 color: Colors.black),
//                           )
//                         ],
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         currentPage++;
//                         loadingMorePosts = true;
//                       });
//                       _loadMorePosts();
//                     },
//                     color: Colors.white,
//                     splashColor: Colors.black54,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                         color: Colors.white,
//                         width: 2,
//                         style: BorderStyle.solid,
//                       ),
//                       borderRadius: BorderRadius.circular(50),
//                     ),
//                   ),
//                 ),
//         ),
//       ],
//     );
//   }

//   _walletTabView() {
//     if (loadingWallet) {
//       return Container(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(
//                 top: 120,
//               ),
//               child: SizedBox(
//                 width: 46,
//                 height: 46,
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     if (loadWalletError) {
//       return Container(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 300, child: TryAgain(getUserWallet)),
//           ],
//         ),
//       );
//     }
//     return Container(
//       padding: EdgeInsets.all(
//         GlobalConstants.of(context).spacingNormal,
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(bottom: 6),
//                         child: Text(
//                           "${AppLocalizations.of(context)!.balanceIn} OOz",
//                           textAlign: TextAlign.right,
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(
//                           top: 4,
//                           right: 8,
//                           bottom: 4,
//                           left: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Color(0xfffc23a6),
//                           ),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(30),
//                           ),
//                         ),
//                         child: RichText(
//                           text: TextSpan(
//                             text: "OOz ",
//                             style: TextStyle(color: Colors.black, fontSize: 18),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text: wallet != null
//                                     ? wallet.totalBalance.toString()
//                                     : "0,00",
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 6),
//             child: Container(
//               child: TabBar(
//                 controller: _tabControllerTransactions,
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 indicatorColor: Color(0xfffc23a6),
//                 indicatorWeight: 4,
//                 isScrollable: false,
//                 labelColor: Colors.black,
//                 labelStyle: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 unselectedLabelColor: Colors.black.withOpacity(0.5),
//                 onTap: (index) {
//                   tabIndexSelected = index;
//                   if (this.tabIndexSelected == 1) {
//                     if (this.receivedWalletTransfers.length <= 0) {
//                       getUserTransactionHistory("received");
//                     }
//                   } else if (this.tabIndexSelected == 2) {
//                     if (this.sentWalletTransfers.length <= 0) {
//                       getUserTransactionHistory("sent");
//                     }
//                   } else {
//                     if (this.allWalletTransfers.length <= 0) {
//                       getUserTransactionHistory();
//                     }
//                   }
//                 },
//                 tabs: [
//                   Tab(
//                     text: AppLocalizations.of(context)!.all,
//                   ),
//                   Tab(
//                     text: AppLocalizations.of(context)!.received,
//                   ),
//                   Tab(
//                     text: AppLocalizations.of(context)!.sent,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 16,
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabControllerTransactions,
//               children: [
//                 WalletTransferHistory(
//                     walletTransferGroup: this.allWalletTransfers),
//                 WalletTransferHistory(
//                     walletTransferGroup: this.receivedWalletTransfers),
//                 WalletTransferHistory(
//                     walletTransferGroup: this.sentWalletTransfers),
//               ],
//             ),
//           ),
//           loadingTransactions
//               ? Center(child: CircularProgressIndicator())
//               : FlatButton(
//                   child: Padding(
//                     padding: EdgeInsets.all(
//                       GlobalConstants.of(context).spacingSmall,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Icon(Icons.expand_more_rounded,
//                               color: Colors.black),
//                         )
//                       ],
//                     ),
//                   ),
//                   onPressed: () {
//                     if (this.tabIndexSelected == 1) {
//                       setState(() {
//                         walletTransferReceivedCurrentPage++;
//                       });
//                       getUserTransactionHistory("received");
//                     } else if (this.tabIndexSelected == 2) {
//                       setState(() {
//                         walletTransferSentCurrentPage++;
//                       });
//                       getUserTransactionHistory("sent");
//                     } else {
//                       setState(() {
//                         walletTransferCurrentPage++;
//                       });
//                       getUserTransactionHistory();
//                     }
//                   },
//                   color: Colors.white,
//                   splashColor: Colors.black54,
//                   shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                       color: Colors.white,
//                       width: 2,
//                       style: BorderStyle.solid,
//                     ),
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//           SizedBox(
//             height: 16,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TabItem extends StatelessWidget {
//   final String iconAssetPath;
//   final String text;
//   final Color backgroundColor;
//   final Color borderBottomColor;
//   final bool isActiveTab;

//   TabItem({
//     required this.iconAssetPath,
//     required this.text,
//     required this.backgroundColor,
//     required this.borderBottomColor,
//     required this.isActiveTab,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Opacity(
//       opacity: (this.isActiveTab ? 1 : 0.5),
//       child: Column(
//         children: [
//           SizedBox(
//             width: 33,
//             height: 33,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: this.backgroundColor,
//                 borderRadius: BorderRadius.all(Radius.circular(150)),
//               ),
//               child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: EdgeInsets.all(2),
//                   child: ImageIcon(
//                     AssetImage(this.iconAssetPath),
//                     color: Colors.black,
//                     size: 36,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               this.text,
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//           Container(
//             height: 3,
//             decoration: BoxDecoration(
//               color: this.borderBottomColor,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class CircleActionButton extends StatelessWidget {
//   final String iconAssetPath;
//   final String text;
//   final Function onClick;

//   CircleActionButton(
//       {required this.iconAssetPath, required this.text, required this.onClick});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         right: GlobalConstants.of(context).spacingNormal,
//       ),
//       child: Column(
//         children: [
//           Ink(
//             decoration: const ShapeDecoration(
//               color: Color(0xfffd81cc),
//               shape: CircleBorder(),
//             ),
//             child: IconButton(
//               icon: ImageIcon(
//                 AssetImage(this.iconAssetPath),
//               ),
//               color: Colors.white,
//               iconSize: 30,
//               onPressed: () => this.onClick,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(6),
//             child: Text(
//               this.text,
//               style: TextStyle(color: Colors.black, fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Avatar extends StatelessWidget {
//   String? photoUrl;
//   List<Badge>? badges;
//   String? modal;

//   Avatar({this.photoUrl, this.badges, this.modal});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: (MediaQuery.of(context).size.width * .40) - 16,
//       height: (MediaQuery.of(context).size.width * .40) - 16,
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: this.modal == "profile" ? 3.0 : 0,
//           color: this.modal == "profile"
//               ? (this.badges!.length > 0)
//                   ? Color(0Xff39A7B2)
//                   : Colors.black
//               : Colors.white,
//         ),
//         borderRadius: BorderRadius.circular(150),
//       ),
//       child: Stack(
//         fit: StackFit.loose,
//         children: [
//           Container(
//             width: (MediaQuery.of(context).size.width * .40) - 16,
//             height: (MediaQuery.of(context).size.width * .40) - 16,
//             child: (this.photoUrl != null
//                 ? CircleAvatar(
//                     backgroundImage: NetworkImage("${this.photoUrl}"),
//                     radius: 16,
//                   )
//                 : CircleAvatar(
//                     backgroundImage:
//                         AssetImage("assets/icons_profile/profile.png"),
//                     radius: 16,
//                   )),
//           ),
//           if (this.badges!.length > 0)
//             Padding(
//               padding: EdgeInsets.only(
//                   top: (MediaQuery.of(context).size.width * .02)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       showModalBottomSheet(
//                         context: context,
//                         barrierColor: Colors.black.withAlpha(1),
//                         backgroundColor: Colors.black.withAlpha(1),
//                         builder: (BuildContext context) {
//                           return SnackBarWidget(
//                             menu: AppLocalizations.of(context)!.badgeSower,
//                             text: AppLocalizations.of(context)!
//                                 .theSowerBadgeIsAwardedToIndividualsAndOrganizationsThatAreLeadingConsistentWorkToHelpRegeneratePlanetEarth,
//                             about: AppLocalizations.of(context)!.learnMore,
//                             contact: {
//                               "text":
//                                   AppLocalizations.of(context)!.areYouASowerToo,
//                               "textLink":
//                                   AppLocalizations.of(context)!.getInContact,
//                             },
//                           );
//                         },
//                       );
//                     },
//                     child: Container(
//                       width: 33,
//                       height: 33,
//                       child: Image.network(this.badges?[0].icon as String),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class DataProfile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height * .15,
//       width: MediaQuery.of(context).size.width / 2,
//       padding: EdgeInsets.only(right: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/badge_hero_user.png',
//                 valueData: '100',
//                 colorIcon: Color(0xff01E8F8),
//               ),
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/badge_hero_city.png',
//                 valueData: '100',
//                 colorIcon: Color(0xff01A9E4),
//               ),
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/badge_hero_earth.png',
//                 valueData: '100',
//                 colorIcon: Color(0xff0073EA),
//               ),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/add.png',
//                 valueData: '100',
//               ),
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/navegation.png',
//                 valueData: '100',
//               ),
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/ootopia.png',
//                 valueData: '100',
//               ),
//               IconDataProfile(
//                 pathIcon: 'assets/icons_profile/double_ootopia.png',
//                 valueData: '100',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class IconDataProfile extends StatelessWidget {
//   String pathIcon;
//   String? valueData;
//   Color? colorIcon;

//   IconDataProfile({required this.pathIcon, this.valueData, this.colorIcon});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         ImageIcon(
//           AssetImage(this.pathIcon),
//           color: colorIcon,
//         ),
//         Text(' ' + (this.valueData != null ? this.valueData! : '--'))
//       ],
//     );
//   }
// }

// class GridPosts extends StatelessWidget {
//   final context;
//   final List<TimelinePost> posts;
//   final String userId;
//   final Function getPostCallback;

//   GridPosts(
//       {this.context,
//       required this.posts,
//       required this.userId,
//       required this.getPostCallback});

//   _goToTimelinePost(posts, postSelected) {
//     PageViewController.instance.addPage(TimelineScreenProfileScreen(
//       {
//         "userId": userId,
//         "posts": posts,
//         "postSelected": postSelected,
//       },
//     ));

//     this.getPostCallback();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return this.posts.length > 0
//         ? GridView.count(
//             padding: const EdgeInsets.all(16),
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//             crossAxisCount: 4,
//             shrinkWrap: true,
//             physics: ClampingScrollPhysics(),
//             children: List.generate(posts.length, (index) {
//               return GestureDetector(
//                 onTap: () => _goToTimelinePost(posts, index),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(14),
//                     ),
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(
//                         posts[index].thumbnailUrl,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           )
//         : Expanded(
//             child: Center(child: Text(AppLocalizations.of(context)!.noPosts)),
//           );
//   }
// }
