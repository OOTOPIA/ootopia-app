import 'package:flutter/material.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;


class MenuProfile extends StatelessWidget with SecureStoreMixin {
  final String profileName;
  String appVersion;

  MenuProfile({this.profileName, this.appVersion});

  clearAuth(context) async {
    await cleanAuthToken();
    Navigator.of(context).pushNamed(
        PageRoute.Page.timelineScreen.route
    );
  }

  // goToGame() {}

  goToProfile(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset('assets/images/logo.png', height: 30),
            decoration: BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffC0D9E8),
                  Color(0xffffffff),
                ],
              ),
            ),
          ),
          ItemMenu(
            pathImage: 'assets/icons_profile/menu_profile.png',
            title: 'Profile',
            onTapFunction: goToProfile,
          ),
          // ItemMenu(
          //   pathImage: 'assets/icons_profile/menu_game.png',
          //   title: 'Game',
          //   onTapFunction: goToProfile,
          // ),
          ItemMenu(
            pathImage: 'assets/icons_profile/menu_left.png',
            title: 'Sair',
            onTapFunction: clearAuth,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Text(
                        'OOTOPIA App Version $appVersion.',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Feito com amor neste planeta maravilhoso.',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Logado como $profileName',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}

class ItemMenu extends StatelessWidget {
  final String pathImage;
  final String title;
  final void Function(BuildContext context) onTapFunction;

  ItemMenu({this.onTapFunction, this.pathImage, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapFunction(context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ImageIcon(
                AssetImage(this.pathImage),
                color: Colors.black87,
                size: 32,
              ),
            ),
            Text(
              this.title,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
