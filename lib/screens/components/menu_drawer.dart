import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/avatar_photo_widget.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/shared/snackbar_component.dart';
import 'package:ootopia_app/theme/light/colors.dart';
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
    Future.delayed(Duration.zero, () async {
      this.getAppInfo();
    });
  }

  Future<void> getAppInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      this.appVersion = '${info.version}+${info.buildNumber}';
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
                            color: Colors.black,
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
                                top: GlobalConstants.of(context)
                                    .intermediateSpacing),
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
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 4.0),
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
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
                        SvgPicture.asset(
                          "assets/icons_profile/laurel_wreath.svg",
                          width: 18,
                          height: 17,
                          color: Color(0xff018f9c),
                        ),
                        Text(
                          '${authStore!.currentUser!.totalTrophyQuantity}',
                          style: TextStyle(
                              color: Color(0xff018F9C),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
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
                        RichText(
                          text: TextSpan(
                              text: AppLocalizations.of(context)!.earn,
                              style: TextStyle(
                                  color: LightColors.grey, fontSize: 10),
                              children: [
                                TextSpan(
                                  text: " OOz ",
                                  style: TextStyle(
                                      color: LightColors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .whenTheySignup,
                                  style: TextStyle(
                                      color: LightColors.grey, fontSize: 10),
                                )
                              ]),
                        ),
                      ],
                    ),
                    leading: Padding(
                      padding: MediaQuery.of(context).size.width > 300
                          ? const EdgeInsets.only(bottom: 3.0, left: 4)
                          : EdgeInsets.all(0),
                      child: Image.asset(
                        'assets/icons/add-user-plus.png',
                        color: Colors.black,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
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
                          style:
                              TextStyle(color: LightColors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    leading: Image.asset(
                      'assets/icons/ooz-black.png',
                      width: 24,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
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
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.supportCenter}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.questions} / ${AppLocalizations.of(context)!.suggestions}',
                          style:
                              TextStyle(color: LightColors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    leading: Image.asset(
                      'assets/icons/chat-small.png',
                      width: 24,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(PageRoute.Page.chatWithUsersScreen.route);
                    },
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.appVersion} OOTOPIA $appVersion.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: LightColors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .madeWithLoveOnThisWonderfulPlanet,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: LightColors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'devmagic.com.br \n ootopia.org',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: LightColors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(primary: Colors.black),
                      onPressed: () async {
                        // if (widget.onTapLogoutItem != null) {
                        //   widget.onTapLogoutItem!();
                        // }
                        clearAuth(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/logout.png',
                            width: 18.22,
                            height: 19.05,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppLocalizations.of(context)!.exit,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
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

class DrawerWithNoCurrentUser extends StatefulWidget {
  const DrawerWithNoCurrentUser({
    Key? key,
    required this.appVersion,
  }) : super(key: key);

  final String? appVersion;

  @override
  State<DrawerWithNoCurrentUser> createState() =>
      _DrawerWithNoCurrentUserState();
}

class _DrawerWithNoCurrentUserState extends State<DrawerWithNoCurrentUser> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.white, width: 0))),
            padding: EdgeInsets.only(bottom: 0, top: 0, left: 15, right: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: EdgeInsets.only(bottom: 6),
                    icon: Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.black,
                    ),
                    onPressed: () {
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
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/icons/user-plus-black.png',
                          width: 15.83,
                          height: 18.99,
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.login}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.enterToOotopia}',
                              style: TextStyle(
                                fontSize: 10,
                                color: LightColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        PageRoute.Page.loginScreen.route,
                      );
                    },
                  ),
                ),
              ],
            )),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.appVersion} OOTOPIA ${widget.appVersion}.\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: LightColors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!
                      .madeWithLoveOnThisWonderfulPlanet,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: LightColors.grey),
                ),
                Text(
                  '\ndevmagic.com.br \n ootopia.org',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: LightColors.grey),
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
