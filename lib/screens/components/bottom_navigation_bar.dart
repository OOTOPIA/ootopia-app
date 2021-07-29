import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/screens/home/components/home_store.dart';
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
    return Observer(
      builder: (_) => Container(
        height: 50,
        padding: EdgeInsets.symmetric(
          horizontal: GlobalConstants.of(context).screenHorizontalSpace,
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => this.onTap(0),
                  icon: SvgPicture.asset(
                    'assets/icons/home_icon.svg',
                    color: _checkIsSelected(0)
                        ? selectedIconColor
                        : unselectedIconColor,
                  ),
                  iconSize: 28,
                ),
                IconButton(
                  onPressed: () => this.onTap(1),
                  icon: SvgPicture.asset(
                    'assets/icons/compass.svg',
                    color: unselectedIconColor,
                  ),
                  iconSize: 28,
                ),
                IconButton(
                  onPressed: () => this.onTap(2),
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
                IconButton(
                  onPressed: () => this.onTap(3),
                  icon: SvgPicture.asset(
                    'assets/icons/ooz_circle_icon.svg',
                    color: unselectedIconColor,
                  ),
                  iconSize: 28,
                ),
                IconButton(
                  onPressed: () => this.onTap(4),
                  icon: SvgPicture.asset(
                    'assets/icons/profile_icon.svg',
                    color: _checkIsSelected(4)
                        ? selectedIconColor
                        : unselectedIconColor,
                  ),
                  iconSize: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _checkIsSelected(int index) {
    bool selected = false;
    switch (index) {
      case 0:
        selected = (homeStore.currentPageWidget is TimelinePage);
        break;
      case 4:
        selected = (homeStore.currentPageWidget is ProfileScreen);
        break;
    }
    return selected;
  }
}
