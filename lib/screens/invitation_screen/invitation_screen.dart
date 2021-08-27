import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/users/invitation_code_model.dart';
import 'package:ootopia_app/screens/invitation_screen/components/default_invatition_code.dart';
import 'package:ootopia_app/screens/invitation_screen/components/sower_invitation_code.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_store.dart';
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
    InvitationStore invitationStore = Provider.of<InvitationStore>(context);
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 21),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: RichText(
                      text: TextSpan(
                        text:
                            AppLocalizations.of(context)!.pictureBySeattleTilth,
                        style: TextStyle(color: Colors.black87, fontSize: 10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: FutureBuilder<List<InvitationCodeModel>?>(
                      future: invitationStore.getCodes(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              if (snapshot.data![index].type != 'sower') {
                                return SowerInvitationCode(
                                    sowerCode: '${snapshot.data![index].code}');
                              }
                              return DefaultInvitationCode(
                                  defaultCode: '${snapshot.data![index].code}');
                            });
                      }),
                ),
                SizedBox(
                  height: 24,
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
