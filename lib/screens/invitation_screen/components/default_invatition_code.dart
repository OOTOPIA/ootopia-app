import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DefaultInvitationCode extends StatefulWidget {
  final String defaultCode;
  const DefaultInvitationCode({required this.defaultCode});

  @override
  _DefaultInvitationCodeState createState() => _DefaultInvitationCodeState();
}

class _DefaultInvitationCodeState extends State<DefaultInvitationCode> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
              flex: 5,
              fit: FlexFit.tight,
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
                subtitle: Text(
                  AppLocalizations.of(context)!.sendWelcomeInvitationCode,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      await SocialShare.shareOptions(
                        AppLocalizations.of(context)!
                            .joinToOOTOPIA
                            .replaceAll('%USER_CODE%', '${widget.defaultCode}'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff003694),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Color(0xff018F9C),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 3, bottom: 3),
                      child: Text(
                        '${widget.defaultCode}',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      AppLocalizations.of(context)!.shareThisCode,
                      softWrap: true,
                      style: TextStyle(color: Color(0xff003694), fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
