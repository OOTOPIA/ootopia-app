import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/bottom_navigation_bar.dart';
import 'package:ootopia_app/screens/components/keep_alive_page.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/new_post_uploaded_message.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/components/menu_drawer.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/home/components/regeneration_game.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class HomeScreen extends StatefulWidget {
  Map<String, dynamic>? args;

  HomeScreen({Key? key, this.args}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late AuthStore authStore;
  HomeStore? homeStore;

  List<StatefulWidget> pages = [
    TimelinePage(null),
    ProfilePage(),
    ProfileScreen(null),
  ];

  Widget? currentPageWidget;
  bool createdPostAlertAlreadyShowed = false;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    controller = PageViewController.instance.newController();
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
    authStore = Provider.of<AuthStore>(context);
    if (homeStore == null) {
      homeStore = Provider.of<HomeStore>(context);
    }
    return WillPopScope(
      onWillPop: () async {
        return PageViewController.instance.back();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarBrightness: Brightness.dark,
        ),
        child: Observer(
          builder: (_) => Scaffold(
            key: _key,
            appBar: appBar,
            drawer: MenuDrawer(
              onTapProfileItem: () {
                _openProfile();
              },
              onTapLogoutItem: () {
                homeStore?.stopDailyGoalTimer();
                _goToPage(0);
              },
            ),
            body: Stack(
              children: [
                PageView.builder(
                  pageSnapping: false,
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    homeStore?.setCurrentPageIndex(index);
                    homeStore?.setCurrentPageWidget(pages[index]);
                    setState(() {});
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return KeepAlivePage(child: pages[index]);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: homeStore != null &&
                            (homeStore!.showCreatedPostAlert &&
                                !homeStore!.createdPostAlertAlreadyShowed) &&
                            !createdPostAlertAlreadyShowed
                        ? 1
                        : 0,
                    duration: Duration(milliseconds: 300),
                    child: NewPostUploadedMessageBox(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: AppBottomNavigationBar(
              onTap: _bottomOnTapButtonHandler,
            ),
          ),
        ),
      ),
    );
  }

  _bottomOnTapButtonHandler(int index) {
    if (homeStore?.currentPageIndex == index) {
      return;
    }
    setState(() {
      switch (index) {
        case 0:
          _goToPage(0);
          break;
        case 2:
          if (authStore.currentUser == null) {
            Navigator.of(context).pushNamed(
              PageRoute.Page.loginScreen.route,
              arguments: {
                "returnToPageWithArgs": {
                  "pageRoute": PageRoute.Page.cameraScreen.route,
                  "arguments": null
                }
              },
            );
          } else {
            Navigator.of(context).pushNamed(PageRoute.Page.cameraScreen.route);
          }
          break;
        case 3:
          if (authStore.currentUser == null) {
            Navigator.of(context).pushNamed(
              PageRoute.Page.loginScreen.route,
              arguments: {
                "returnToPageWithArgs": {
                  "pageRoute": PageRoute.Page.cameraScreen.route,
                  "arguments": null
                }
              },
            );
          } else {
            _goToPage(1);
          }
          break;
        case 4:
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
          } else {
            _openProfile();
            _goToPage(2);
          }
          break;
        default:
      }
    });
  }

  _openProfile() {
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
      return;
    }
    if (authStore.currentUser!.registerPhase == 2) {
      _goToPage(1);
    } else {
      Navigator.of(context).pushNamed(
        PageRoute.Page.registerPhase2Screen.route,
        arguments: {
          "returnToPageWithArgs": {
            "currentPageName": "my_profile",
            "arguments": null
          }
        },
      );
    }
  }

  _goToPage(int index) {
    PageViewController.instance.controller.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  _checkStores() {
    homeStore?.getDailyGoalStats();
    homeStore?.startDailyGoalTimer();
    if (authStore.currentUser == null) {
      authStore.checkUserIsLogged();
    }
    if (homeStore?.currentPageWidget == null) {
      homeStore?.setCurrentPageWidget(pages[0]);
    }
  }

  _checkPageParams() {
    Timer(Duration(milliseconds: 1000), () {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
                "my_profile" &&
            authStore.currentUser != null) {
          if (authStore.currentUser!.registerPhase == 2) {
            setState(() {
              _goToPage(1);
            });
          } else if (authStore.currentUser!.registerPhase == 1) {
            Navigator.of(context).pushNamed(
              PageRoute.Page.registerPhase2Screen.route,
              arguments: {
                "returnToPageWithArgs": {
                  "currentPageName": "my_profile",
                  "arguments": null
                }
              },
            );
          }
        } else if (widget.args!['returnToPageWithArgs']['pageRoute'] != null) {
          Navigator.of(context).pushNamed(
            widget.args!['returnToPageWithArgs']['pageRoute'],
            arguments: widget.args!['returnToPageWithArgs']['arguments'],
          );
        }
      }
      if (widget.args != null &&
          widget.args!['createdPost'] != null &&
          widget.args!['createdPost'] == true) {
        homeStore?.setShowCreatedPostAlert(true);
        Timer(Duration(seconds: 5), () {
          homeStore?.setShowCreatedPostAlert(false);
          homeStore?.setCreatedPostAlertAlreadyShowed(true);
          setState(() {});
        });
      }
    });
  }

  get appBar => AppBar(
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.all(3),
          child: Image.asset(
            'assets/images/logo.png',
            height: 34,
          ),
        ),
        toolbarHeight: homeStore?.currentPageIndex == 0 ? 104 : 45,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.light,
        bottom: homeStore?.currentPageIndex == 0
            ? PreferredSize(
                child: RegenerationGame(),
                preferredSize: const Size.fromHeight(0.0),
              )
            : null,
        leading: Padding(
          padding: EdgeInsets.only(
            left: GlobalConstants.of(context).screenHorizontalSpace - 9,
          ),
          child: IconButton(
            icon: Icon(
              FeatherIcons.menu,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => _key.currentState!.openDrawer(),
          ),
        ),
        actions: [
          remainingTime,
        ],
      );

  Widget get remainingTime => Visibility(
        visible: authStore.currentUser != null,
        child: Padding(
          padding: EdgeInsets.only(
            right: 19,
          ),
          child: GestureDetector(
            onTap: () => setState(() {
              if (homeStore != null && homeStore!.dailyGoalStats != null) {
                homeStore?.showRemainingTime = !homeStore!.showRemainingTime;
                homeStore?.showRemainingTimeEnd = !homeStore!.showRemainingTime;
              }
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: homeStore != null && homeStore!.showRemainingTime
                          ? 4
                          : 11),
                  child: Icon(
                    FeatherIcons.clock,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                AnimatedOpacity(
                  opacity:
                      homeStore != null && homeStore!.showRemainingTime ? 1 : 0,
                  duration: Duration(milliseconds: 500),
                  onEnd: () {},
                  child: Visibility(
                    visible: homeStore != null && homeStore!.showRemainingTime,
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
      );
}
