import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/edit_profile_screen/edit_profile_screen.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/new_post_uploaded_message.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/components/menu_drawer.dart';
import 'package:ootopia_app/screens/learning_tracks/learning_tracks_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/profile_screen_store.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:smart_page_navigation/smart_page_navigation.dart';

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

    Future.delayed(Duration.zero, () {
      //controller.resetNavigation();
      controller.addOnInsertPageListener((index) {
        print("addOnInsertPageListener >> ${controller.pages}");
        if (mounted) setState(() {});
      });
      controller.addOnPageChangedListener((index) {
        print("addOnPageChangedListener >> ${controller.pages}");
        if (mounted) setState(() {});
      });
      controller.addOnBackPageListener(() {
        print("addOnBackPageListener >> ${controller.pages}");
        if (mounted) setState(() {});
      });
      controller.addOnResetNavigation(() {
        print("addOnResetNavigation >> ${controller.pages}");
        if (mounted) setState(() {});
      });
      // controller.addOnBottomNavigationBarChanged((index) {
      //   print("addOnBottomNavigationBarChanged >> ${controller.pages}");
      //   if (index == PageViewController.TAB_INDEX_PROFILE) {
      //     print("ABRIU MEU PERFIL");
      //   }
      //   if (mounted) setState(() {});
      // });
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
    controller = SmartPageController.of(context).init(
      initialPages: [
        TimelinePage(null),
        LearningTracksScreen(),
        LearningTracksScreen(),
        WalletPage(),
        ProfileScreen(null),
      ],
    );
    Color selectedIconColor = Theme.of(context).accentColor;
    Color unselectedIconColor =
        Theme.of(context).iconTheme.color!.withOpacity(0.7);
    authStore = Provider.of<AuthStore>(context);
    profileStore = Provider.of<ProfileScreenStore>(context);

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
          statusBarBrightness: Brightness.dark,
        ),
        child: Observer(builder: (_) {
          return Scaffold(
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
                    onTapWalletItem: () {
                      controller.goToPage(PageViewController.TAB_INDEX_WALLET);
                    },
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
            bottomNavigationBar: new SmartPageBottomNavigationBar(
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
                  selectedWidget: SvgPicture.asset(
                    'assets/icons/ooz_circle_icon.svg',
                    color: selectedIconColor,
                  ),
                  unselectedWidget: SvgPicture.asset(
                    'assets/icons/ooz_circle_icon.svg',
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
              onTap: (int index, BuildContext context) {
                var result = true;
                switch (index) {
                  case PageViewController.TAB_INDEX_TIMELINE:
                    controller.resetNavigation();
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
                      Navigator.of(context)
                          .pushNamed(PageRoute.Page.cameraScreen.route);
                    }
                    result = false;
                    break;
                  case PageViewController.TAB_INDEX_WALLET:
                    print("caiu 1");
                    if (authStore.currentUser == null) {
                      print("caiu 2");
                      Navigator.of(context).pushNamed(
                        PageRoute.Page.loginScreen.route,
                        arguments: {
                          "returnToPageWithArgs": {
                            "currentPageName": "wallet",
                            "arguments": null
                          }
                        },
                      );
                      result = false;
                    }
                    break;
                  case PageViewController.TAB_INDEX_PROFILE:
                    if (authStore.currentUser == null) {
                      result = false;
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
                      result = openProfile();
                    }
                    break;
                  default:
                }
                print("caiu 3");
                return result;
              },
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

    if (authStore.currentUser!.registerPhase != 2) {
      Navigator.of(context).pushNamed(
        PageRoute.Page.registerPhase2Screen.route,
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
    if (authStore.currentUser == null) {
      authStore.checkUserIsLogged();
    }
    setState(() {});
  }

  _checkPageParams() {
    Timer(Duration(milliseconds: 1000), () {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
                "my_profile" &&
            authStore.currentUser != null) {
          if (authStore.currentUser!.registerPhase == 2) {
            setState(() {
              controller.selectBottomTab(4, context);
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
        oozToRewardAfterSendPost = widget.args!['oozToReward'];
        Timer(Duration(seconds: 5), () {
          homeStore?.setShowCreatedPostAlert(false);
          homeStore?.setCreatedPostAlertAlreadyShowed(true);
          setState(() {});
        });
      }
    });
  }

  PreferredSizeWidget? currentAppBar() {
    return (controller.pages[controller.currentPageIndex]
                is EditProfileScreen &&
            controller.pages.length > controller.initialPages.length)
        ? null
        : controller.currentBottomIndex == PageViewController.TAB_INDEX_PROFILE
            ? appBarProfile
            : appBar;
  }

  get appBarProfile => PreferredSize(
        preferredSize: Size(double.infinity, 45),
        child: SafeArea(
          child: Container(
            height: 45,
            padding: EdgeInsets.symmetric(horizontal: 24),
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
                  width: 85,
                  child: Text(
                    AppLocalizations.of(context)!.profile,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 34,
                ),
                Container(
                  width: 85,
                  child: TextButton.icon(
                      onPressed: () {
                        controller.insertPage(
                          EditProfileScreen(),
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Color(0xff03145C),
                        size: 18,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.edit,
                        style: TextStyle(
                          color: Color(0xff03145C),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      );

  get appBar => AppBar(
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
        actions: [
          if (controller.pages.length <= 5) remainingTime,
        ],
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
