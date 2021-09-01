import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/data/models/users/invitation_code_model.dart';
import 'package:ootopia_app/screens/invitation_screen/components/default_invatition_code.dart';
import 'package:ootopia_app/screens/invitation_screen/components/sower_invitation_code.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_store.dart';
import 'package:provider/provider.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/kids.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, right: 21),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!
                              .pictureBySeattleTilth,
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
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .inviteYourFriendsToJoinOOTOPIA,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    child: FutureBuilder<List<InvitationCodeModel>?>(
                        future: invitationStore.getCodes(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data![index].type == 'sower') {
                                  return SowerInvitationCode(
                                      sowerCode:
                                          '${snapshot.data![index].code}');
                                }
                                return DefaultInvitationCode(
                                    defaultCode:
                                        '${snapshot.data![index].code}');
                              });
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
