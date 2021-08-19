import 'package:flutter/material.dart';
import 'package:ootopia_app/data/models/users/badges_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
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
          child: Avatar(
            photoUrl: authStore!.currentUser == null
                ? null
                : authStore!.currentUser!.photoUrl,
            badges: authStore!.currentUser!.badges,
            modal: "profile",
          ),
        ),
        Text(
          '${authStore!.currentUser!.fullname}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.personalGoal),
                Text(
                  '10m |',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.add),
                Text('23')
              ],
            ),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Invite your friends'),
            subtitle: Text('earn OOz when they signup'),
            leading: Icon(Icons.person_add),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('OOz Wallet'),
            subtitle: Text('check your transactions'),
            leading: Image.asset(
              'assets/icons/ooz-coin-small.png',
              color: Colors.black,
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Questions / suggestions'),
            subtitle: Text('send your feedback'),
            leading: Icon(Icons.person_add),
            trailing: Icon(Icons.arrow_forward_ios),
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
            ],
          ),
        ),
      ],
    ));
  }
}

class Avatar extends StatelessWidget {
  String? photoUrl;
  List<Badge>? badges;
  String? modal;

  Avatar({this.photoUrl, this.badges, this.modal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * .40) - 16,
      height: (MediaQuery.of(context).size.width * .40) - 16,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          width: this.modal == "profile" ? 3.0 : 0,
          color: this.modal == "profile"
              ? (this.badges!.length > 0)
                  ? Color(0Xff39A7B2)
                  : Colors.black
              : Colors.white,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width * .40) - 16,
            height: (MediaQuery.of(context).size.width * .40) - 16,
            child: (this.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage("${this.photoUrl}"),
                    radius: 16,
                  )
                : CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/icons_profile/profile.png"),
                    radius: 16,
                  )),
          ),
          if (this.badges!.length > 0)
            Padding(
              padding: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.width * .02)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        barrierColor: Colors.black.withAlpha(1),
                        backgroundColor: Colors.black.withAlpha(1),
                        builder: (BuildContext context) {
                          return SnackBarWidget(
                            menu: AppLocalizations.of(context)!.badgeSower,
                            text: AppLocalizations.of(context)!
                                .theSowerBadgeIsAwardedToIndividualsAndOrganizationsThatAreLeadingConsistentWorkToHelpRegeneratePlanetEarth,
                            about: AppLocalizations.of(context)!.learnMore,
                            contact: {
                              "text":
                                  AppLocalizations.of(context)!.areYouASowerToo,
                              "textLink":
                                  AppLocalizations.of(context)!.getInContact,
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 33,
                      height: 33,
                      child: Image.network(this.badges?[0].icon as String),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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
