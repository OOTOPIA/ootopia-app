import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ootopia_app/data/models/users/badges_model.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/home/components/page_view_controller.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/avatar_photo_widget.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';

class MenuDrawer extends StatefulWidget {
  final Function? onTapProfileItem;
  final Function? onTapLogoutItem;
  final Function? onTapWalletItem;
  MenuDrawer(
      {this.onTapProfileItem, this.onTapLogoutItem, this.onTapWalletItem});
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> with SecureStoreMixin {
  String? appVersion;

  AnalyticsTracking trackingEvents = AnalyticsTracking.getInstance();
  AuthStore? authStore;
  SmartPageController controller = SmartPageController.getInstance();

  @override
  void initState() {
    super.initState();
    this.getAppInfo();
  }

  Future<void> getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      this.appVersion = info.version;
    });
  }

  clearAuth(context) async {
    await authStore!.logout();
    ChatDialogController.instance.resetSavedData();
    this.trackingEvents.trackingLoggedOut();
    controller.resetNavigation();
    Navigator.of(context).pushNamedAndRemoveUntil(
      PageRoute.Page.homeScreen.route,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    if (authStore!.currentUser == null) {
      return DrawerWithNoCurrentUser(appVersion: appVersion);
    } else {
      return Drawer(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          padding: EdgeInsets.only(bottom: 16),
                          icon: Icon(
                            Icons.close,
                            size: 15,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        child: InkWell(
                          onTap: () {
                            if (widget.onTapProfileItem != null) {
                              widget.onTapProfileItem!();
                            }
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: GlobalConstants.of(context).spacingNormal),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: GlobalConstants.of(context)
                                          .spacingNormal),
                                ),
                                AvatarPhotoWidget(
                                  sizePhotoUrl: 114,
                                  photoUrl: authStore!.currentUser!.photoUrl,
                                  isBadges:
                                      authStore!.currentUser!.badges!.length >
                                          0,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      barrierColor: Colors.black.withAlpha(1),
                                      backgroundColor:
                                          Colors.black.withAlpha(1),
                                      builder: (BuildContext context) {
                                        return SnackBarWidget(
                                          menu: AppLocalizations.of(context)!
                                              .badgeChangeMakerPro,
                                          text: AppLocalizations.of(context)!
                                              .theChangeMakerProBadgeIsAwardedToIndividualsAndOrganizationsThatAreLeadingConsistentWorkToHelpRegeneratePlanetEarth,
                                          about: AppLocalizations.of(context)!
                                              .learnMore,
                                          contact: {
                                            "text":
                                                AppLocalizations.of(context)!
                                                    .areYouAChangeMakerProToo,
                                            "textLink":
                                                AppLocalizations.of(context)!
                                                    .getInContact,
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${authStore!.currentUser!.fullname}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.personalGoal}:',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${authStore!.currentUser!.dailyLearningGoalInMinutes}m',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('|'),
                        Image.asset(
                          'assets/icons/Icon-metro-trophy.png',
                        ),
                        Text(
                          '${authStore!.currentUser!.totalTrophyQuantity}',
                          style: TextStyle(
                              color: Color(0xff00A5FC),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ))),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.inviteYourFriends}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.earnOzzSignup}',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    leading: Padding(
                      padding: MediaQuery.of(context).size.width > 300
                          ? const EdgeInsets.only(bottom: 3.0, left: 4)
                          : EdgeInsets.all(0),
                      child: Icon(
                        FeatherIcons.userPlus,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      controller.insertPage(InvitationScreen());
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.0,
                  ))),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OOz ${AppLocalizations.of(context)!.wallet}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.checkYourTransactions}',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    leading: Image.asset(
                      'assets/icons/ooz-coin-small.png',
                      color: Colors.black,
                      width: 24,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      if (widget.onTapWalletItem != null) {
                        widget.onTapWalletItem!();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.questions} / ${AppLocalizations.of(context)!.suggestions}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.sendYourFeedback}',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    leading: Image.asset(
                      'assets/icons/chat-small.png',
                      width: 24,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pushNamed(
                            PageRoute.Page.chatWithUsersScreen.route);
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Text(
                          "OOTOPIA ${AppLocalizations.of(context)!.appVersion} $appVersion.\n",
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
                          '\ndevmagic.com.br \n ootopia.org',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(primary: Colors.black),
                      onPressed: () async {
                        // if (widget.onTapLogoutItem != null) {
                        //   widget.onTapLogoutItem!();
                        // }
                        clearAuth(context);
                      },
                      icon: Icon(Icons.logout),
                      label: Text(AppLocalizations.of(context)!.exit),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
  }
}

class DrawerWithNoCurrentUser extends StatelessWidget {
  const DrawerWithNoCurrentUser({
    Key? key,
    required this.appVersion,
  }) : super(key: key);

  final String? appVersion;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border(bottom: BorderSide(color: Colors.white, width: 0))),
            padding: EdgeInsets.only(bottom: 70, top: 10, left: 15, right: 15),
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 1.0,
              ))),
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
                  size: 20,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    PageRoute.Page.loginScreen.route,
                  );
                },
              ),
            )),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "OOTOPIA ${AppLocalizations.of(context)!.appVersion} $appVersion.\n",
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
                  '\ndevmagic.com.br \n ootopia.org',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
