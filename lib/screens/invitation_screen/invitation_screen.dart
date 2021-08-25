import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/screens/auth/auth_store.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  @override
  Widget build(BuildContext context) {
    AuthStore authStore = Provider.of<AuthStore>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 17,
                ),
                Text(
                  AppLocalizations.of(context)!.back,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: 34,
        ),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset('assets/images/kids.png'),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.eachOneMakeADiference,
                  style: TextStyle(
                    color: Color(0xff003694),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.inviteYourFriendsToJoinOOTOPIA,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24,
                ),
                authStore.currentUser!.badges!.isNotEmpty
                    ? Column(
                        children: [
                          Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Flexible(
                                flex: 3,
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .sowerInvitationCode,
                                      style: TextStyle(
                                        color: Color(0xff018F9C),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(AppLocalizations.of(context)!
                                      .sendSowerInvitationCode),
                                ),
                              ),
                              Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await SocialShare.shareOptions(
                                        AppLocalizations.of(context)!
                                            .joinToOOTOPIA
                                            .replaceAll(
                                                '%USER_CODE%', 'ADCE963'),
                                      );
                                    },
                                    child: Chip(
                                      label: Text(
                                        'ADCE963',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      backgroundColor: Color(0xff018F9C),
                                      padding:
                                          EdgeInsets.only(left: 25, right: 25),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.shareThisCode,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Color(0xff018F9C), fontSize: 12),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 24,
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!.welcomeInvitationCode,
                            style: TextStyle(
                              color: Color(0xff003694),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        subtitle: Text(AppLocalizations.of(context)!
                            .sendWelcomeInvitationCode),
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await SocialShare.shareOptions(
                              AppLocalizations.of(context)!
                                  .joinToOOTOPIA
                                  .replaceAll('%USER_CODE%', 'ADCE963'),
                            );
                          },
                          child: Chip(
                            label: Text(
                              'ADCE963',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            backgroundColor: Color(0xff003694),
                            padding: EdgeInsets.only(left: 25, right: 25),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.shareThisCode,
                          softWrap: true,
                          style:
                              TextStyle(color: Color(0xff003694), fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    iconSize: 40,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PageRoute.Page.chatWithUsersScreen.route,
                      );
                    },
                    icon: Image.asset('assets/icons/crisp_icon.png'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
