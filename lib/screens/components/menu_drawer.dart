import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return authStore!.currentUser == null
        ? Drawer(
            child: Column(
            children: [
              DrawerHeader(
                  child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.person),
                ),
                title: Text('${AppLocalizations.of(context)!.login}'),
                subtitle:
                    Text('${AppLocalizations.of(context)!.enterToOotopia}'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 23,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    PageRoute.Page.loginScreen.route,
                  );
                },
              )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "OOTOPIA ${AppLocalizations.of(context)!.appVersion} $appVersion.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .madeWithLoveOnThisWonderfulPlanet,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'devmagic.com.br \n ootopia.org',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            ],
          ))
        : Visibility(
            visible: authStore!.currentUser != null && authStore != null,
            child: Drawer(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    padding: EdgeInsets.all(0),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 15,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Avatar(
                              photoUrl: authStore!.currentUser == null
                                  ? null
                                  : authStore!.currentUser!.photoUrl,
                              badges: authStore!.currentUser!.badges,
                              modal: "profile",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${authStore!.currentUser!.fullname}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Card(
                    child: Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.personalGoal}:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '  ${authStore!.currentUser!.dailyLearningGoalInMinutes}m | ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Icon(FeatherIcons.userPlus, color: Color(0xff00A5FC)),
                          Text(
                            '${authStore!.currentUser!.badges!.length}',
                            style: TextStyle(color: Color(0xff00A5FC)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ))),
                    child: ListTile(
                      title: Text(
                        '${AppLocalizations.of(context)!.inviteYourFriends}',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.earnOzzSignup}',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(top: 12),
                        child: Icon(FeatherIcons.userPlus, color: Colors.black),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                      onTap: () {},
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ))),
                    child: ListTile(
                      title: Text(
                        'OOz ${AppLocalizations.of(context)!.wallet}',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.checkYourTransactions}',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset(
                          'assets/icons/ooz-coin-small.png',
                          color: Colors.black,
                          width: 24,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                      onTap: () {},
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ))),
                    child: ListTile(
                      title: Text(
                        '${AppLocalizations.of(context)!.questions} / ${AppLocalizations.of(context)!.suggestions}',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        '${AppLocalizations.of(context)!.sendYourFeedback}',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      leading: Container(
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset(
                          'assets/icons/chat-small.png',
                          width: 24,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                      onTap: () {},
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
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .madeWithLoveOnThisWonderfulPlanet,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'devmagic.com.br \n ootopia.org',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                )
                              ],
                            )),
                        Visibility(
                            visible: authStore != null &&
                                authStore!.currentUser != null,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                      primary: Colors.black),
                                  onPressed: () {
                                    clearAuth(context);
                                    if (widget.onTapLogoutItem != null) {
                                      widget.onTapLogoutItem!();
                                    }
                                  },
                                  icon: Icon(Icons.logout),
                                  label:
                                      Text(AppLocalizations.of(context)!.exit)),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          );
  }
}

class Avatar extends StatelessWidget {
  final String? photoUrl;
  final List<Badge>? badges;
  final String? modal;

  Avatar({this.photoUrl, this.badges, this.modal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width * .31) - 16,
      height: (MediaQuery.of(context).size.width * .32) - 16,
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
        children: [
          Container(
            width: (MediaQuery.of(context).size.width * .40) - 16,
            height: (MediaQuery.of(context).size.width * .40) - 16,
            child: (this.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage("${this.photoUrl}"),
                  )
                : CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/icons_profile/profile.png"),
                  )),
          ),
          if (this.badges!.length > 0)
            Padding(
              padding: EdgeInsets.only(
                  top: (MediaQuery.of(context).size.width * .01)),
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
                      width: 25,
                      height: 25,
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
