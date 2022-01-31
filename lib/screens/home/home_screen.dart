import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/main.dart' as main;
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/components/default_app_bar.dart';
import 'package:ootopia_app/screens/components/menu_drawer.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/new_post_uploaded_message.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_screen.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  HomeScreen({Key? key, this.args}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, SecureStoreMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late AuthStore authStore;
  HomeStore? homeStore;
  late TimelineStore timelineStore;
  late TimelinePostBloc timelinePostBloc;

  late ProfileScreenStore profileStore;
  Widget? currentPageWidget;
  bool createdPostAlertAlreadyShowed = false;
  double oozToRewardAfterSendPost = 0;
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');
  late SmartPageController controller;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    homeStore?.prefs?.setBool("showSplash", false);

    controller = SmartPageController.newInstance(
      context: context,
      initialPages: [
        TimelinePage(null),
        LearningTracksScreen(),
        LearningTracksScreen(),
        MarketplaceScreen(),
        ProfileScreen(null),
      ],
    );

    initDynamicLinks();

    controller.addListener(() {
      if (mounted) setState(() {});
    });

    Future.delayed(Duration(milliseconds: 1000), () async {
      _checkStores();
      _checkPageParams();
      FlutterBackgroundService().sendData(
        {
          "action": "START_SYNC",
          "message":
              AppLocalizations.of(context)!.updatingRegenerationGameStatus,
        },
      );
      if (await FlutterBackgroundService().isServiceRunning() &&
          !await getUserIsLoggedIn()) {
        FlutterBackgroundService().sendData(
          {"action": "stopService"},
        );
      }
    });
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("Meu link gerado ---> ${dynamicLinkData.link.path}");
      print("Meu link gerado ---> ${dynamicLinkData.link}");
      print("Meu link gerado ---> ${dynamicLinkData.link.queryParameters}");
      
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _checkStores();
        break;
      case AppLifecycleState.inactive:
        //homeStore?.stopDailyGoalTimer();
        //print("app in inactive");
        break;
      case AppLifecycleState.paused:
        //homeStore?.stopDailyGoalTimer();
        //print("app in paused");
        break;
      case AppLifecycleState.detached:
        //homeStore?.stopDailyGoalTimer();
        //print("app in detached");
        homeStore?.prefs?.setBool("showSplash", true);
        break;
    }
  }

  @override
  void dispose() {
    FlutterBackgroundService.initialize(main.onStartService);
    FlutterBackgroundService().sendData(
      {
        "action": "START_SYNC",
        "message": AppLocalizations.of(context)!.updatingRegenerationGameStatus,
      },
    );
    homeStore?.stopDailyGoalTimer();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timelinePostBloc = BlocProvider.of<TimelinePostBloc>(context);
    Color selectedIconColor = Theme.of(context).accentColor;
    Color unselectedIconColor = Color(0XFF3A4046);
    authStore = Provider.of<AuthStore>(context);
    profileStore = Provider.of<ProfileScreenStore>(context);
    timelineStore = Provider.of<TimelineStore>(context);

    if (homeStore == null) {
      homeStore = Provider.of<HomeStore>(context);
    }
    return WillPopScope(
      onWillPop: () async {
        var result = await controller.back();
        if (result &&
            !(await ChatDialogController.instance
                .getChatHasAlreadyBeenOpenedToday())) {
          result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.dialogTitleBeforeExiting,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black87,
                      ),
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          AppLocalizations.of(context)!
                              .dialogDescriptionBeforeExiting,
                          style: Theme.of(context).textTheme.bodyText2),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child:
                        Text(AppLocalizations.of(context)!.shareMyExperience),
                    onPressed: () async {
                      await launch("https://forms.gle/6qWokM6ipf7ac4fL8");
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.notNow),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          );
          if (!result) {
            Navigator.of(context).pushNamed(
              PageRoute.Page.chatWithUsersScreen.route,
            );
          }
        }
        return result;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarBrightness: Brightness.light,
        ),
        child: Observer(builder: (_) {
          return Scaffold(
            resizeToAvoidBottomInset: homeStore!.resizeToAvoidBottomInset,
            key: _scaffoldKey,
            appBar: currentAppBar(),
            drawer: controller.currentBottomIndex ==
                    PageViewController.TAB_INDEX_PROFILE
                ? null
                : MenuDrawer(
                    onTapProfileItem: () {
                      openProfile();
                    },
                    onTapLogoutItem: () {
                      controller
                          .goToPage(PageViewController.TAB_INDEX_TIMELINE);
                      controller.resetNavigation();
                      setState(() {});
                    },
                    onTapWalletItem: () => controller.insertPage(WalletPage()),
                  ),
            body: Stack(
              children: [
                SmartPageNavigation(
                  controller: controller,
                ),
                Visibility(
                  visible: homeStore!.seeCrisp && controller.currentBottomIndex != PageViewController.HIDE_BOTTOMBAR,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      iconSize: 40,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          PageRoute.Page.chatWithUsersScreen.route,
                        );
                      },
                      icon: Image.asset('assets/icons/crisp_icon.png'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible:
                        (homeStore != null && homeStore!.showCreatedPostAlert),
                    child: AnimatedOpacity(
                      opacity: homeStore != null &&
                              (homeStore!.showCreatedPostAlert &&
                                  !homeStore!.createdPostAlertAlreadyShowed) &&
                              !createdPostAlertAlreadyShowed
                          ? 1
                          : 0,
                      duration: Duration(milliseconds: 300),
                      child: NewPostUploadedMessageBox(
                        text: AppLocalizations.of(context)!
                            .yourPublicationIsBeingProcessed
                            .replaceAll("%",
                                "${currencyFormatter.format(oozToRewardAfterSendPost)}"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: controller.currentBottomIndex ==
                PageViewController.HIDE_BOTTOMBAR  ? null :
            Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    color: Color(0xff707070).withOpacity(0.2),
                    width: MediaQuery.of(context).size.width,
                    height: 2,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      image:  DecorationImage(
                        image: AssetImage(
                          'assets/images/butterfly_bottom.png',
                        ),
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin:  homeStore!.iphoneHasNotch
                        ? EdgeInsets.only(bottom: 16)
                        : EdgeInsets.only(bottom: 0),
                    child: new SmartPageBottomNavigationBar(
                      controller: controller,
                      options: SmartPageBottomNavigationOptions(
                        height: 50,
                        indicatorColor: Theme.of(context).accentColor,
                        backgroundColor: Colors.transparent,
                        showBorder: false,
                        showIndicator: true,
                        borderColor: Color(0xff707070).withOpacity(0.20),
                        selectedColor: selectedIconColor,
                        unselectedColor: unselectedIconColor,
                      ),
                      children: [
                        BottomIcon(
                          selectedWidget: SvgPicture.asset(
                            'assets/icons/home_icon.svg',
                            color: selectedIconColor,
                          ),
                          unselectedWidget: SvgPicture.asset(
                            'assets/icons/home_icon.svg',
                            color: unselectedIconColor,
                          ),
                        ),
                        BottomIcon(
                          selectedWidget: SvgPicture.asset(
                            'assets/icons/compass.svg',
                            color: selectedIconColor,
                          ),
                          unselectedWidget: SvgPicture.asset(
                            'assets/icons/compass.svg',
                            color: unselectedIconColor,
                          ),
                        ),
                        BottomIcon(
                          selectedWidget: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SvgPicture.asset(
                              'assets/icons/plus.svg',
                              // color: selectedIconColor,
                            ),
                          ),
                          unselectedWidget: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: SvgPicture.asset(
                              'assets/icons/plus.svg',
                            ),
                          ),
                        ),
                        BottomIcon(
                          selectedWidget: SvgPicture.asset(
                            "assets/icons/marketplace.svg",
                            color: selectedIconColor,
                          ),
                          unselectedWidget: SvgPicture.asset(
                            "assets/icons/marketplace.svg",
                            color: unselectedIconColor,
                          ),
                        ),
                        BottomIcon(
                          selectedWidget: SvgPicture.asset(
                            'assets/icons/profile_icon.svg',
                            color: selectedIconColor,
                          ),
                          unselectedWidget: SvgPicture.asset(
                            'assets/icons/profile_icon.svg',
                            color: unselectedIconColor,
                          ),
                        ),
                      ],
                      onTap: (int index) {
                        var result = true;
                        switch (index) {
                          case PageViewController.TAB_INDEX_TIMELINE:
                            if (controller.pages[controller.currentPageIndex]
                            is TimelinePage)
                              timelineStore.goToTopTimeline(timelinePostBloc);

                            controller.resetNavigation();
                            break;
                          case PageViewController.TAB_INDEX_LEARNING_TRACKS:
                            break;
                          case PageViewController.TAB_INDEX_CAMERA:
                            if (authStore.currentUser == null) {
                              Navigator.of(context).pushNamed(
                                PageRoute.Page.loginScreen.route,
                                arguments: {
                                  "returnToPageWithArgs": {
                                    "currentPageName": "camera",
                                    "arguments": null
                                  }
                                },
                              );
                            } else {
                              Navigator.of(context)
                                  .pushNamed(PageRoute.Page.cameraScreen.route);
                            }
                            result = false;
                            break;
                          case PageViewController.TAB_INDEX_MARKETPLACE:
                            break;
                          case PageViewController.TAB_INDEX_PROFILE:
                            result = openProfile();
                            break;
                          default:
                        }

                        return result;
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  bool openProfile() {
    var result = true;
    if (authStore.currentUser == null) {
      Navigator.of(context).pushNamed(
        PageRoute.Page.loginScreen.route,
        arguments: {
          "returnToPageWithArgs": {
            "currentPageName": "my_profile",
            "arguments": null
          }
        },
      );
      result = false;
    }

    return result;
  }

  _checkStores() async {
    await homeStore?.getDailyGoalStats();
    homeStore?.startDailyGoalTimer();
    if (Platform.isIOS)
      homeStore?.getIphoneHasNotch(ui.window.physicalSize.height.toInt());
    if (authStore.currentUser == null) {
      authStore.checkUserIsLogged();
    }
    setState(() {});
  }

  _checkPageParams() {
    Timer(Duration(milliseconds: 300), () {
      try {
        if (widget.args != null &&
            widget.args!['returnToPageWithArgs'] != null &&
            widget.args!['returnToPageWithArgs']['currentPageName'] != null &&
            authStore.currentUser != null) {
          if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
              "learning_tracks") {
            setState(() {
              controller.selectBottomTab(1);
            });
          }
          if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
              "camera") {
            setState(() {
              controller.selectBottomTab(2);
            });
          }
          if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
              "marketplace") {
            setState(() {
              controller.selectBottomTab(3);
            });
          }
          if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
              "my_profile") {
            setState(() {
              controller.selectBottomTab(4);
            });
          }
        }

        if (widget.args?['returnToPageWithArgs'] != null &&
            widget.args?['returnToPageWithArgs']['pageRoute'] != null) {
          Navigator.of(context).pushNamed(
            widget.args!['returnToPageWithArgs']['pageRoute'],
            arguments: widget.args!['returnToPageWithArgs']['arguments'],
          );
        }

        if (widget.args != null &&
            widget.args!['createdPost'] != null &&
            widget.args!['createdPost'] == true) {
          homeStore?.setShowCreatedPostAlert(true);
          oozToRewardAfterSendPost = widget.args!['oozToReward'];
          Timer(Duration(seconds: 5), () {
            homeStore?.setShowCreatedPostAlert(false);
            homeStore?.setCreatedPostAlertAlreadyShowed(true);
            setState(() {});
          });
        }
      } catch (err) {
        print("Check page params error: $err");
      }
    });
  }

  Widget get currentPage => controller.pages[controller.currentPageIndex];
  bool get hasNavigation =>
      controller.pages.length > controller.initialPages.length;
  bool get isNotWallet =>
      authStore.currentUser != null && !(currentPage is WalletPage);

  PreferredSizeWidget? currentAppBar(){

    if(controller.currentBottomIndex >= PageViewController.TAB_UNSELECTED){
      return appBarBackFromMap;
    }

    return (currentPage is EditProfileScreen && hasNavigation)
        ? null
        : controller.currentBottomIndex ==
                    PageViewController.TAB_INDEX_PROFILE &&
                currentPage is ProfileScreen
            ? appBarProfile
            : controller.currentBottomIndex ==
                        PageViewController.TAB_INDEX_MARKETPLACE &&
                    currentPage is MarketplaceScreen
                ? appBarMarketplace
                : controller.currentBottomIndex ==
                            PageViewController.TAB_INDEX_LEARNING_TRACKS &&
                        currentPage is LearningTracksScreen
                    ? appBarLearningTracks
                    : appBar;
  }

  get appBarLearningTracks => DefaultAppBar(
        components: [
          AppBarComponents.back,
          if (authStore.currentUser != null) AppBarComponents.ooz,
        ],
        onTapLeading: () => controller.back(),
      );

  get appBarMarketplace => DefaultAppBar(
        components: [
          AppBarComponents.back,
          if (authStore.currentUser != null) AppBarComponents.ooz,
        ],
        onTapLeading: () => controller.back(),
      );

  get appBarProfile => DefaultAppBar(
        components: [
          AppBarComponents.back,
          AppBarComponents.edit,
        ],
        onTapAction: () => controller.insertPage(EditProfileScreen()),
        onTapLeading: () => controller.back(),
      );



  get appBarBackFromMap => DefaultAppBar(
      components: [
        AppBarComponents.back,
        if (authStore.currentUser != null) AppBarComponents.ooz,
      ],
      onTapLeading: () {
        setState(() {
          controller.currentBottomIndex =PageViewController.TAB_INDEX_TIMELINE;
          controller.refreshViews();
          controller.showBottomNavigationBar();
          controller.goToPage(PageViewController.TAB_INDEX_TIMELINE);
        });

      },
    );

  get appBar => DefaultAppBar(
        components: [
          if (hasNavigation) AppBarComponents.back,
          if (!hasNavigation) AppBarComponents.menu,
          if (isNotWallet) AppBarComponents.ooz,
        ],
        onTapLeading: () {
          if (!hasNavigation) {
            _scaffoldKey.currentState!.openDrawer();
          } else {
            controller.back();
          }
        },
        onTapTitle: () {
          if (controller.currentBottomIndex ==
              PageViewController.TAB_INDEX_TIMELINE) {
            timelineStore.goToTopTimeline(timelinePostBloc);
          }
        },
      );

  Widget get remainingTime => Observer(
        builder: (_) => Visibility(
          visible: authStore.currentUser != null,
          child: Padding(
            padding: EdgeInsets.only(
              right: 19,
            ),
            child: GestureDetector(
              onTap: () => setState(() {
                if (homeStore != null && homeStore!.dailyGoalStats != null) {
                  homeStore?.showRemainingTime = !homeStore!.showRemainingTime;
                  homeStore?.showRemainingTimeEnd =
                      !homeStore!.showRemainingTime;
                }
              }),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: homeStore != null && homeStore!.showRemainingTime
                          ? 4
                          : 11,
                    ),
                    child: Icon(
                      FeatherIcons.clock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: homeStore != null && homeStore!.showRemainingTime
                        ? 1
                        : 0,
                    duration: Duration(milliseconds: 500),
                    onEnd: () {},
                    child: Visibility(
                      visible:
                          homeStore != null && homeStore!.showRemainingTime,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            homeStore != null ? homeStore!.remainingTime : "",
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff707070),
                                    ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.remaining,
                            style:
                                Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 12,
                                      color: Color(0xff707070),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
