import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/bloc/timeline/timeline_bloc.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/new_post_uploaded_message.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/components/menu_drawer.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_screen.dart';
import 'package:ootopia_app/screens/marketplace/marketplace_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_store.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic>? args;

  HomeScreen({Key? key, this.args}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
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

    controller.addListener(() {
      if (mounted) setState(() {});
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      _checkStores();
      _checkPageParams();
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
    homeStore?.stopDailyGoalTimer();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timelinePostBloc = BlocProvider.of<TimelinePostBloc>(context);
    Color selectedIconColor = Theme.of(context).accentColor;
    Color unselectedIconColor =
        Theme.of(context).iconTheme.color!.withOpacity(0.7);
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
                    onPressed: () => Navigator.of(context).pop(false),
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
            resizeToAvoidBottomInset: false,
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
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    iconSize: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PageRoute.Page.chatWithUsersScreen.route,
                      );
                    },
                    icon: Image.asset('assets/icons/crisp_icon.png'),
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
            bottomNavigationBar: Padding(
              padding: homeStore!.iphoneHasNotch
                  ? EdgeInsets.only(bottom: 16)
                  : EdgeInsets.only(bottom: 0),
              child: new SmartPageBottomNavigationBar(
                controller: controller,
                options: SmartPageBottomNavigationOptions(
                  height: 50,
                  indicatorColor: Theme.of(context).accentColor,
                  backgroundColor: Colors.white,
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
                    selectedWidget: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Icon(
                          FeatherIcons.plus,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    unselectedWidget: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).accentColor,
                        ),
                        child: Icon(
                          FeatherIcons.plus,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  BottomIcon(
                    selectedWidget: Image.asset(
                      "assets/icons/marketplace_selected_icon.png",
                      height: 28,
                    ),
                    unselectedWidget: Image.asset(
                      "assets/icons/marketplace_unselected_icon.png",
                      height: 28,
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
                      if (authStore.currentUser == null) {
                        Navigator.of(context).pushNamed(
                          PageRoute.Page.loginScreen.route,
                          arguments: {
                            "returnToPageWithArgs": {
                              "currentPageName": "learning_tracks",
                              "arguments": null
                            }
                          },
                        );
                        result = false;
                      }
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
                      if (authStore.currentUser == null) {
                        Navigator.of(context).pushNamed(
                          PageRoute.Page.loginScreen.route,
                          arguments: {
                            "returnToPageWithArgs": {
                              "currentPageName": "marketplace",
                              "arguments": null
                            }
                          },
                        );
                        result = false;
                      }
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

  PreferredSizeWidget? currentAppBar() {
    return (controller.pages[controller.currentPageIndex]
                is EditProfileScreen &&
            controller.pages.length > controller.initialPages.length)
        ? null
        : controller.currentBottomIndex ==
                    PageViewController.TAB_INDEX_PROFILE &&
                controller.pages[controller.currentPageIndex] is ProfileScreen
            ? appBarProfile
            : controller.currentBottomIndex ==
                        PageViewController.TAB_INDEX_MARKETPLACE &&
                    controller.pages[controller.currentPageIndex]
                        is MarketplaceScreen
                ? appBarMarketplace
                : appBar;
  }

  get appBarMarketplace => AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.all(3),
          child: Image.asset(
            'assets/images/logo.png',
            height: 34,
          ),
        ),
        toolbarHeight: 45,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: Padding(
          padding: EdgeInsets.only(
            left: GlobalConstants.of(context).screenHorizontalSpace - 9,
          ),
          child: InkWell(
            onTap: () => controller.back(),
            child: Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.arrowLeft,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      AppLocalizations.of(context)!.back,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                )),
          ),
        ),
      );

  get appBarProfile => PreferredSize(
        preferredSize: Size(double.infinity, 45),
        child: SafeArea(
          child: Container(
            height: 45,
            padding: EdgeInsets.symmetric(
                horizontal: GlobalConstants.of(context).intermediateSpacing),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 70,
                  child: Text(
                    AppLocalizations.of(context)!.profile,
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).textTheme.subtitle1!.color,
                        fontSize:
                            Theme.of(context).textTheme.subtitle1!.fontSize,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 34,
                ),
                GestureDetector(
                  onTap: () {
                    controller.insertPage(
                      EditProfileScreen(),
                    );
                  },
                  child: Container(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Image.asset(
                            'assets/icons_profile/feather-edit-2.png',
                            width: 16,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.edit,
                          style: GoogleFonts.roboto(
                            color: Theme.of(context).textTheme.subtitle1!.color,
                            fontSize:
                                Theme.of(context).textTheme.subtitle1!.fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  get appBar => AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: controller.currentBottomIndex ==
                  PageViewController.TAB_INDEX_TIMELINE
              ? () {
                  timelineStore.goToTopTimeline(timelinePostBloc);
                }
              : null,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/logo.png',
              height: 34,
            ),
          ),
        ),
        toolbarHeight: 45,
        elevation: controller.currentBottomIndex ==
                PageViewController.TAB_INDEX_TIMELINE
            ? 0
            : 0.5,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.light,
        leading: Padding(
          padding: EdgeInsets.only(
            left: GlobalConstants.of(context).screenHorizontalSpace - 9,
          ),
          child: controller.pages.length <= 5
              ? IconButton(
                  icon: Icon(
                    FeatherIcons.menu,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                )
              : InkWell(
                  onTap: () => controller.back(),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: Row(
                        children: [
                          Icon(
                            FeatherIcons.arrowLeft,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            AppLocalizations.of(context)!.back,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      )),
                ),
        ),
        // actions: [
        //   if (controller.pages.length <= 5) remainingTime,
        // ],
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
