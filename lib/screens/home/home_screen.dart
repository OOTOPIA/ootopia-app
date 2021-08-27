import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/components/bottom_navigation_bar.dart';
import 'package:ootopia_app/screens/components/keep_alive_page.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/new_post_uploaded_message.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/components/menu_drawer.dart';
import 'package:ootopia_app/screens/learning/learning_tracks_screen.dart';
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

  Widget? currentPageWidget;
  bool createdPostAlertAlreadyShowed = false;
  double oozToRewardAfterSendPost = 0;
  final currencyFormatter = NumberFormat('#,##0.00', 'ID');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    PageViewController.instance.onClickBack = () {
      homeStore?.setCurrentPageWidget(PageViewController.instance.pages[
          PageViewController.instance.pageHistoryTabSelected[
              PageViewController.instance.pageHistoryTabSelected.length - 1]]);
    };

    PageViewController.instance.onAddPage = () {
      setState(() {});
    };

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
        var result = PageViewController.instance.back();
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
          statusBarBrightness: Brightness.dark,
        ),
        child: Observer(
          builder: (_) => Scaffold(
            key: _key,
            appBar: appBar,
            drawer: MenuDrawer(
              onTapProfileItem: () {
                openProfile();
              },
              onTapLogoutItem: () {
                homeStore?.stopDailyGoalTimer();
                _goToPage(0);
              },
              onTapWalletItem: () {
                _goToPage(1);
              },
            ),
            body: Stack(
              children: [
                PageView.builder(
                  pageSnapping: false,
                  controller: PageViewController.instance.controller,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    homeStore?.setCurrentPageIndex(index);
                    if (PageViewController.instance.pages.length <= 5) {
                      homeStore?.setCurrentPageWidget(
                          PageViewController.instance.pages[index]);
                    }
                    setState(() {});
                  },
                  itemCount: PageViewController.instance.pages.length,
                  itemBuilder: (context, index) {
                    return KeepAlivePage(
                        child: PageViewController.instance.pages[index]);
                  },
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
        case PageViewController.TAB_INDEX_TIMELINE:
          _goToPage(PageViewController.TAB_INDEX_TIMELINE);
          PageViewController.instance.resetPages();
          homeStore
              ?.setCurrentPageWidget(PageViewController.instance.pages[index]);
          break;

        case PageViewController.TAB_INDEX_LEARNING_TRACKS:
          if (PageViewController.instance.pages.length > 5) {
            PageViewController.instance.addPage(LearningTracksScreen());
          } else {
            _goToPage(PageViewController.TAB_INDEX_LEARNING_TRACKS);
          }
          homeStore
              ?.setCurrentPageWidget(PageViewController.instance.pages[index]);

          break;
        case PageViewController.TAB_INDEX_CAMERA:
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
        case PageViewController.TAB_INDEX_WALLET:
          if (authStore.currentUser == null) {
            Navigator.of(context).pushNamed(
              PageRoute.Page.loginScreen.route,
              arguments: {
                "returnToPageWithArgs": {
                  "currentPageName": "wallet",
                  "arguments": null
                }
              },
            );
          } else {
            if (PageViewController.instance.pages.length > 5) {
              PageViewController.instance.addPage(WalletPage());
            } else {
              _goToPage(PageViewController.TAB_INDEX_WALLET);
            }
            homeStore?.setCurrentPageWidget(
                PageViewController.instance.pages[index]);
          }
          break;
        case PageViewController.TAB_INDEX_PROFILE:
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
            openProfile();
          }
          break;
        default:
      }
    });
  }

  openProfile() {
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
      if (PageViewController.instance.pages.length > 5) {
        PageViewController.instance.addPage(ProfileScreen());
      } else {
        _goToPage(PageViewController.TAB_INDEX_PROFILE);
      }
      homeStore?.setCurrentPageWidget(PageViewController
          .instance.pages[PageViewController.TAB_INDEX_PROFILE]);
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
    PageViewController.instance.goToPage(
      index,
    );
  }

  _checkStores() {
    homeStore?.getDailyGoalStats();
    homeStore?.startDailyGoalTimer();
    if (authStore.currentUser == null) {
      authStore.checkUserIsLogged();
    }
    if (homeStore?.currentPageWidget == null) {
      homeStore?.setCurrentPageWidget(PageViewController.instance.pages[0]);
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
        homeStore?.setCurrentPageWidget(PageViewController
            .instance.pages[PageViewController.TAB_INDEX_TIMELINE]);
        homeStore?.setCurrentPageIndex(PageViewController.TAB_INDEX_TIMELINE);
        homeStore?.setShowCreatedPostAlert(true);
        oozToRewardAfterSendPost = widget.args!['oozToReward'];
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
          child: PageViewController.instance.pages.length <= 5
              ? IconButton(
                  icon: Icon(
                    FeatherIcons.menu,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () => _key.currentState!.openDrawer(),
                )
              : InkWell(
                  onTap: () => PageViewController.instance.back(),
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
