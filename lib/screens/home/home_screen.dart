import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/components/bottom_navigation_bar.dart';
import 'package:ootopia_app/screens/components/keep_alive_page.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/profile_screen/components/menu_profile.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late AuthStore authStore;
  late HomeStore homeStore;

  List<StatefulWidget> pages = [
    TimelinePage(null),
    ProfileScreen(null),
  ];

  Widget? currentPageWidget;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _checkStores());
  }

  @override
  void dispose() {
    homeStore.stopDailyGoalTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    homeStore = Provider.of<HomeStore>(context);
    _checkPageParams();
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
            drawer: MenuProfile(),
            body: PageView.builder(
              pageSnapping: false,
              controller: PageViewController.instance.controller,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                homeStore.setCurrentPageIndex(index);
                homeStore.setCurrentPageWidget(pages[index]);
                setState(() {});
              },
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return KeepAlivePage(child: pages[index]);
              },
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
    if (homeStore.currentPageIndex == index) {
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
            _goToPage(1);
          }
          break;
        default:
      }
    });
  }

  _goToPage(int index) {
    PageViewController.instance.controller.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  _checkStores() {
    try {
      if (authStore.currentUser == null) {
        authStore.checkUserIsLogged();
      }
      if (homeStore.dailyGoalStats == null) {
        homeStore.startDailyGoalTimer();
      }
      homeStore.getDailyGoalStats();
      if (homeStore.currentPageWidget == null) {
        homeStore.setCurrentPageWidget(pages[0]);
      }
    } catch (err) {
      print("TA ERRADO $err");
    }
  }

  _checkPageParams() {
    Timer(Duration(milliseconds: 1000), () {
      if (widget.args != null && widget.args!['returnToPageWithArgs'] != null) {
        if (widget.args!['returnToPageWithArgs']['currentPageName'] ==
                "my_profile" &&
            authStore.currentUser != null &&
            authStore.currentUser!.registerPhase == 1) {
          setState(() {
            PageViewController.instance.controller.jumpTo(1);
          });
        } else if (widget.args!['returnToPageWithArgs']['pageRoute'] != null) {
          print("CHANGEEESSSS ${widget.args!['returnToPageWithArgs']}");
          Navigator.of(context).pushNamed(
            widget.args!['returnToPageWithArgs']['pageRoute'],
            arguments: widget.args!['returnToPageWithArgs']['arguments'],
          );
        }
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
        toolbarHeight: homeStore.currentPageIndex == 0 ? 104 : 45,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Brightness.light,
        bottom: homeStore.currentPageIndex == 0
            ? PreferredSize(
                child: RegenerationGame(),
                preferredSize: const Size.fromHeight(0.0),
              )
            : null,
        leading: Padding(
          padding: EdgeInsets.only(
            left: GlobalConstants.of(context).screenHorizontalSpace,
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

  Widget get remainingTime => Padding(
        padding: EdgeInsets.only(
          right: 19,
        ),
        child: GestureDetector(
          onTap: () => setState(() {
            print("OOPS ${homeStore.dailyGoalStats}");
            if (homeStore.dailyGoalStats != null) {
              homeStore.showRemainingTime = !homeStore.showRemainingTime;
              homeStore.showRemainingTimeEnd = !homeStore.showRemainingTime;
            }
          }),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                FeatherIcons.clock,
                color: Theme.of(context).iconTheme.color,
              ),
              AnimatedOpacity(
                opacity: homeStore.showRemainingTime ? 1 : 0,
                duration: Duration(milliseconds: 500),
                onEnd: () {},
                child: Visibility(
                  visible: homeStore.showRemainingTime,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          homeStore.remainingTime,
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
                ),
              )
            ],
          ),
        ),
      );
}
