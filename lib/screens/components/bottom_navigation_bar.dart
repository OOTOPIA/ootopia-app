import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/learning/learning_tracks_screen.dart';
import 'package:ootopia_app/screens/wallet/wallet_screen.dart';
import 'package:ootopia_app/screens/profile_screen/profile_screen.dart';
import 'package:ootopia_app/screens/timeline/timeline_screen.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:provider/provider.dart';

class AppBottomNavigationBar extends StatefulWidget {
  Function onTap;
  AppBottomNavigationBar({Key? key, required this.onTap}) : super(key: key);

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  late Function onTap;
  late HomeStore homeStore;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    onTap = widget.onTap;
  }

  @override
  Widget build(BuildContext context) {
    Color selectedIconColor = Theme.of(context).accentColor;
    Color unselectedIconColor =
        Theme.of(context).iconTheme.color!.withOpacity(0.7);
    homeStore = Provider.of<HomeStore>(context);
    final borderWidth = (MediaQuery.of(context).size.width / 5);
    return Observer(
      builder: (_) => Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).primaryColorDark,
              width: 1,
            ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () =>
                          this._onTap(PageViewController.TAB_INDEX_TIMELINE),
                      icon: SvgPicture.asset(
                        'assets/icons/home_icon.svg',
                        color: _checkIsSelected(
                                PageViewController.TAB_INDEX_TIMELINE)
                            ? selectedIconColor
                            : unselectedIconColor,
                      ),
                      iconSize: 28,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () => this
                          ._onTap(PageViewController.TAB_INDEX_LEARNING_TRACKS),
                      icon: SvgPicture.asset(
                        'assets/icons/compass.svg',
                        color: _checkIsSelected(
                                PageViewController.TAB_INDEX_LEARNING_TRACKS)
                            ? selectedIconColor
                            : unselectedIconColor,
                      ),
                      iconSize: 28,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () => this._onTap(2),
                      icon: Container(
                        width: 46,
                        height: 46,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () =>
                          this._onTap(PageViewController.TAB_INDEX_WALLET),
                      icon: SvgPicture.asset(
                        'assets/icons/ooz_circle_icon.svg',
                        color: _checkIsSelected(
                                PageViewController.TAB_INDEX_WALLET)
                            ? selectedIconColor
                            : unselectedIconColor,
                      ),
                      iconSize: 28,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: IconButton(
                      onPressed: () =>
                          this._onTap(PageViewController.TAB_INDEX_PROFILE),
                      icon: SvgPicture.asset(
                        'assets/icons/profile_icon.svg',
                        color: _checkIsSelected(
                                PageViewController.TAB_INDEX_PROFILE)
                            ? selectedIconColor
                            : unselectedIconColor,
                      ),
                      iconSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedPositioned(
              left: borderWidth * currentIndex,
              child: Container(
                width: borderWidth,
                height: 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                ),
              ),
              duration: Duration(milliseconds: 100),
            ),
          ],
        ),
      ),
    );
  }

  _checkIsSelected(int index) {
    bool selected = false;
    switch (index) {
      case PageViewController.TAB_INDEX_TIMELINE:
        selected = (homeStore.currentPageWidget is TimelinePage);
        break;
      case PageViewController.TAB_INDEX_LEARNING_TRACKS:
        selected = (homeStore.currentPageWidget is LearningTracksScreen);
        break;
      case PageViewController.TAB_INDEX_CAMERA:
        selected = (homeStore.currentPageWidget is LearningTracksScreen);
        break;
      case PageViewController.TAB_INDEX_WALLET:
        selected = (homeStore.currentPageWidget is WalletPage);
        break;
      case PageViewController.TAB_INDEX_PROFILE:
        selected = (homeStore.currentPageWidget is ProfileScreen);
        break;
    }
    if (selected) {
      this.currentIndex = index;
    }
    return selected;
  }

  _onTap(int index) {
    this.onTap(index);
  }
}
