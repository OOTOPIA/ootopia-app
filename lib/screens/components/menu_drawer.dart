import 'package:flutter/material.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  Function? onTapProfileItem;
  Function? onTapLogoutItem;
  MenuDrawer({Key? key, this.onTapProfileItem, this.onTapLogoutItem})
      : super(key: key);
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> with SecureStoreMixin {
  String? appVersion;

  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  AuthStore? authStore;

  @override
  void initState() {
    super.initState();
    this.getAppInfo();
  }

  clearAuth(context) async {
    authStore!.logout();
    ChatDialogController.instance.resetSavedData();
    this.trackingEvents.trackingLoggedOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
      PageRoute.Page.homeScreen.route,
      ModalRoute.withName('/'),
    );
  }

  Future<void> getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      this.appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
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
          title: AppLocalizations.of(context)!.profile,
          onTapFunction: (context) {
            Navigator.of(context).pop();
            if (widget.onTapProfileItem != null) {
              widget.onTapProfileItem!();
            }
          },
        ),
        Visibility(
          visible: authStore != null && authStore!.currentUser != null,
          child: ItemMenu(
            pathImage: 'assets/icons_profile/menu_left.png',
            title: AppLocalizations.of(context)!.exit,
            onTapFunction: (context) {
              clearAuth(context);
              if (widget.onTapLogoutItem != null) {
                widget.onTapLogoutItem!();
              }
            },
          ),
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
                        "OOTOPIA ${AppLocalizations.of(context)!.appVersion} $appVersion.",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .madeWithLoveOnThisWonderfulPlanet,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        (authStore!.currentUser != null
                            ? "${AppLocalizations.of(context)!.loggedInAs} ${authStore!.currentUser!.fullname!}"
                            : ""),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}

class ItemMenu extends StatelessWidget {
  final String pathImage;
  final String title;
  final void Function(BuildContext context) onTapFunction;

  ItemMenu({
    required this.onTapFunction,
    required this.pathImage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
