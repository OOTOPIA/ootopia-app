import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ootopia_app/data/repositories/user_repository.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/screens/chat_with_users/chat_dialog_controller.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_screen.dart';
import 'package:ootopia_app/screens/profile_screen/components/avatar_photo_widget.dart';
import 'package:ootopia_app/shared/FirebaseMessaging/push_notification.service.dart';
import 'package:ootopia_app/shared/analytics.server.dart';
import 'package:ootopia_app/shared/app_usage_time.dart';
import 'package:ootopia_app/shared/background_butterfly_bottom.dart';
import 'package:ootopia_app/shared/background_butterfly_top.dart';
import 'package:ootopia_app/shared/global-constants.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/theme/light/colors.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:smart_page_navigation/smart_page_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final ScrollController _firstController = ScrollController();
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  PushNotification pushNotification = PushNotification.getInstance();

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
    await userRepository.updateTokenDeviceUser(null);
    await authStore!.logout();
    ChatDialogController.instance.resetSavedData();
    this.trackingEvents.trackingLoggedOut();
    AppUsageTime.instance.sendToApi();
    //Adicionei esse delayed para dar tempo de enviar o tempo de uso do app
    Future.delayed(Duration(milliseconds: 100), () {
      controller.resetNavigation();
      Navigator.of(context).pushNamedAndRemoveUntil(
        PageRoute.Page.homeScreen.route,
        (Route<dynamic> route) => false,
      );
    });
  }

  openTermsOfUse(
      BuildContext context, bool next, bool privacyInformation) async {
    Navigator.of(context).pushNamed(
      PageRoute.Page.termsOfUseScreen.route,
      arguments: {
        'filename': 'terms_of_use',
        'onAccept': () {
          setState(() {
            if (next) {
              openPrivacyPolicy(context, true);
            }
          });
        },
        'buttonText': next
            ? AppLocalizations.of(context)!.next
            : AppLocalizations.of(context)!.close,
        'fileSuffix':
            privacyInformation ? 'privacyinformation' : 'informationdrawer'
      },
    );
  }

  openPrivacyPolicy(BuildContext context, bool privacyInformation) async {
    Navigator.of(context).pushNamed(
      PageRoute.Page.termsOfUseScreen.route,
      arguments: {
        'filename': 'privacy_policy',
        'onAccept': () {
          setState(() {});
        },
        'buttonText': AppLocalizations.of(context)!.close,
        'fileSuffix':
            privacyInformation ? 'privacyinformation' : 'informationdrawer'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<AuthStore>(context);
    if (authStore!.currentUser == null) {
      return DrawerWithNoCurrentUser(appVersion: appVersion);
    } else {
      return Drawer(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              BackgroundButterflyTop(),
              BackgroundButterflyBottom(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 16,
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeArea(
                              top: true,
                              child: Container(
                                height: 126,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        padding: EdgeInsets.only(bottom: 25),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AvatarPhotoWidget(
                                                sizePhotoUrl: 100,
                                                photoUrl:
                                                    authStore!.currentUser!.photoUrl,
                                                isBadges: authStore!
                                                        .currentUser!.badges!.length >
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
                            ),
                            Container(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${authStore!.currentUser!.fullname}',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                              child: Card(
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
                                        '${authStore!.currentUser!.dailyLearningGoalInMinutes}min',
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
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: Scrollbar(
                                isAlwaysShown: true,
                                radius: Radius.circular(10.0),
                                thickness: 3,
                                controller: _firstController,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    controller: _firstController,
                                    children: [
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.inviteYourFriends}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                    text:
                                                        AppLocalizations.of(context)!
                                                            .earn,
                                                    style: TextStyle(
                                                        color: LightColors.grey,
                                                        fontSize: 10),
                                                    children: [
                                                      TextSpan(
                                                        text: " OOz ",
                                                        style: TextStyle(
                                                            color: LightColors.grey,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                      TextSpan(
                                                        text: AppLocalizations.of(
                                                                context)!
                                                            .whenTheySignup,
                                                        style: TextStyle(
                                                            color: LightColors.grey,
                                                            fontSize: 10),
                                                      )
                                                    ]),
                                              ),
                                            ],
                                          ),
                                          leading: Padding(
                                            padding:
                                                MediaQuery.of(context).size.width >
                                                        300
                                                    ? const EdgeInsets.only(
                                                        bottom: 3.0, left: 4)
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.yourOOZWallet}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                '${AppLocalizations.of(context)!.checkYourTransactions}',
                                                style: TextStyle(
                                                    color: LightColors.grey,
                                                    fontSize: 10),
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
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0,
                                        ))),
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.giveYourOpinion}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                '${AppLocalizations.of(context)!.itIsVeryImportant}',
                                                style: TextStyle(
                                                    color: LightColors.grey,
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                          leading: Image.asset(
                                            'assets/icons/icon_apptest.png',
                                            width: 24,
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 15,
                                            color: Colors.black,
                                          ),
                                          onTap: () async {
                                            await launch(
                                                "https://forms.gle/6qWokM6ipf7ac4fL8");
                                          },
                                        ),
                                      ),
                                      Container(
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.supportCenter}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                '${AppLocalizations.of(context)!.questions} / ${AppLocalizations.of(context)!.suggestions}',
                                                style: TextStyle(
                                                    color: LightColors.grey,
                                                    fontSize: 10),
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
                                            Navigator.of(context).pushNamed(PageRoute
                                                .Page.chatWithUsersScreen.route);
                                          },
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        child: GestureDetector(
                                          onTap: () {
                                            openTermsOfUse(context, true, true);
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Image.asset(
                                                'assets/icons/icon_lock.png',
                                                width: 18.22,
                                                height: 19.05,
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .yourPrivacyInformation,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Image.asset(
                                              'assets/icons/icon_info.png',
                                              width: 18.22,
                                              height: 19.05,
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                openTermsOfUse(context, false, false);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .termsOfUseDrawer,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!.and,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                openPrivacyPolicy(context, false);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!.privacy,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(top: 8),
                                        child: GestureDetector(
                                          onTap: () async {
                                            // if (widget.onTapLogoutItem != null) {
                                            //   widget.onTapLogoutItem!();
                                            // }
                                            clearAuth(context);
                                          },
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 8,
                                              ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.appVersion} OOTOPIA $appVersion.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: LightColors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .madeWithLoveOnThisWonderfulPlanet,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: LightColors.grey,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'ootopia.org',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: LightColors.grey,
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
        ),
      );
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
