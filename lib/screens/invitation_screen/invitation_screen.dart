import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ootopia_app/data/models/users/invitation_code_model.dart';
import 'package:ootopia_app/screens/invitation_screen/components/default_invatition_code.dart';
import 'package:ootopia_app/screens/invitation_screen/components/sower_invitation_code.dart';
import 'package:ootopia_app/screens/invitation_screen/invitation_store.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({Key? key}) : super(key: key);

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  InvitationStore invitationStore = InvitationStore();

  @override
  void initState() {
    super.initState();
    invitationStore.getCodes();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: ListView(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/plating.png',
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
                          text:
                              AppLocalizations.of(context)!.pictureByRommelDiaz,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    child: body(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget body() {
    if (invitationStore.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: invitationStore.listInvitationCode.map((invitationCode) {
        if (invitationCode.type == 'sower') {
          return SowerInvitationCode(sowerCode: '${invitationCode.code}');
        }
        return DefaultInvitationCode(defaultCode: '${invitationCode.code}');
      }).toList(),
    );
  }
}
