import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SowerInvitationCode extends StatefulWidget {
  final String sowerCode;
  const SowerInvitationCode({required this.sowerCode});

  @override
  _SowerInvitationCodeState createState() => _SowerInvitationCodeState();
}

class _SowerInvitationCodeState extends State<SowerInvitationCode> {
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
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.sowerInvitationCode,
                    style: TextStyle(
                      color: Color(0xff018F9C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.sendSowerInvitationCode,
                  style: TextStyle(fontSize: 14),
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
                            .replaceAll('%USER_CODE%', '${widget.sowerCode}'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff018F9C),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Color(0xff018F9C),
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: Text(
                          '${widget.sowerCode}',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      AppLocalizations.of(context)!.shareThisCode,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(color: Color(0xff018F9C), fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
