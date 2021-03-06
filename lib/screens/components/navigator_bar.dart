import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/user_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:ootopia_app/shared/navigator-state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavigatorBar extends StatefulWidget {
  final Function? onClickButton;

  const NavigatorBar({
    Key? key,
    this.onClickButton,
    this.currentPage,
  }) : super(key: key);

  final String? currentPage;

  @override
  _NavigatorBarState createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> with SecureStoreMixin {
  bool loggedIn = false;
  User? user;

  @override
  void initState() {
    super.initState();
    _checkUserIsLoggedIn();
  }

  void _checkUserIsLoggedIn() async {
    loggedIn = await getUserIsLoggedIn();
    if (loggedIn) {
      user = await getCurrentUser();
      print("LOGGED USER: ${user!.toJson()}");
    }
  }

  renderSnackBar(BuildContext context) {
    return Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.theVideoIsLoading,
          style: TextStyle(color: Colors.black),
        ),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xffC0D9E8),
            Color(0xffffffff),
          ],
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (value) async {
          switch (value) {
            case 0:
              Navigator.popUntil(
                context,
                ModalRoute.withName(PageRoute.Page.timelineScreen.route),
              );

              if (widget.onClickButton != null) {
                widget.onClickButton!();
              }
              break;

            case 1:
              if (!loggedIn) {
                await Navigator.of(context).pushNamed(
                  PageRoute.Page.loginScreen.route,
                  arguments: {
                    "returnToPageWithArgs": {
                      "pageRoute": PageRoute.Page.cameraScreen.route,
                      "arguments": null
                    }
                  },
                );
                return;
              }

              final resultCamera = await Navigator.of(context)
                  .pushNamed(PageRoute.Page.cameraScreen.route);

              if (resultCamera != null) {
                renderSnackBar(context);
              }
              break;

            case 2:
              if (!loggedIn) {
                await Navigator.of(context).pushNamed(
                  PageRoute.Page.loginScreen.route,
                  arguments: {
                    "returnToPageWithArgs": {
                      "pageRoute": PageRoute.Page.myProfileScreen.route,
                      "arguments": null
                    }
                  },
                );
                return;
              } else if (loggedIn) {
                if (user!.registerPhase == 2) {
                  Navigator.of(context).pushNamedIfNotCurrent(
                      PageRoute.Page.myProfileScreen.route);
                } else {
                  Navigator.of(context).pushNamed(
                    PageRoute.Page.registerPhase2Screen.route,
                    arguments: {
                      "returnToPageWithArgs": {
                        "pageRoute": PageRoute.Page.myProfileScreen.route,
                        "arguments": null
                      }
                    },
                  );
                }
              }
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: widget.currentPage == PageRoute.Page.timelineScreen.route
                  ? EdgeInsets.all(4)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: widget.currentPage == PageRoute.Page.timelineScreen.route
                    ? Color(0xff062580).withOpacity(.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(150),
                ),
              ),
              child: ImageIcon(
                AssetImage('assets/icons/home.png'),
                size: widget.currentPage == PageRoute.Page.timelineScreen.route
                    ? 34
                    : 32,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.home,
              style: TextStyle(fontSize: 8),
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: ImageIcon(
          //     AssetImage('assets/icons/search.png'),
          //   ),
          // ignore: deprecated_member_use
          //   title: Text('Search'),
          // ),
          // BottomNavigationBarItem(
          //   icon: ImageIcon(
          //     AssetImage('assets/icons/navegation.png'),
          //   ),
          //   // ignore: deprecated_member_use
          //   title: Text('Share'),
          // ),
          BottomNavigationBarItem(
            icon: Container(
              padding: widget.currentPage == PageRoute.Page.cameraScreen.route
                  ? EdgeInsets.all(4)
                  : EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: widget.currentPage == PageRoute.Page.cameraScreen.route
                    ? Color(0xff598006).withOpacity(.25)
                    : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(150),
                ),
              ),
              child: ImageIcon(
                AssetImage('assets/icons/add.png'),
                size: widget.currentPage == PageRoute.Page.cameraScreen.route
                    ? 34
                    : 32,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.add,
              style: TextStyle(fontSize: 8),
            ),
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding:
                  widget.currentPage == PageRoute.Page.myProfileScreen.route
                      ? EdgeInsets.all(4)
                      : EdgeInsets.all(0),
              decoration: BoxDecoration(
                color:
                    widget.currentPage == PageRoute.Page.myProfileScreen.route
                        ? Color(0xff8F0707).withOpacity(.25)
                        : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(150),
                  topRight: Radius.circular(150),
                ),
              ),
              child: ImageIcon(
                AssetImage('assets/icons/profile.png'),
                size: widget.currentPage == PageRoute.Page.myProfileScreen.route
                    ? 34
                    : 32,
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.profile,
              style: TextStyle(fontSize: 8),
            ),
          ),
          // BottomNavigationBarItem(
          //   icon: ImageIcon(
          //     AssetImage('assets/icons/ootopia.png'),
          //   ),
          //   // ignore: deprecated_member_use
          //   title: Text('Home'),
          // ),
        ],
        // currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
    );
  }
}
