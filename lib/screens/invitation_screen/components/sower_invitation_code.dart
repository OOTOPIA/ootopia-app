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
        Text(
          AppLocalizations.of(context)!.changeMakerProInvitationCode,
          style: TextStyle(
            color: Color(0xff018F9C),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          AppLocalizations.of(context)!.sendSowerInvitationCode,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  await SocialShare.shareOptions(
                    AppLocalizations.of(context)!
                        .joinToOOTOPIA
                        .replaceAll('%USER_CODE%', '*${widget.sowerCode}*'),
                  );
                },
                child: Container(
                  width: 228,
                  decoration: BoxDecoration(
                    color: Color(0xff018F9C),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: Color(0xff018F9C),
                    ),
                  ),
                  padding: EdgeInsets.all(9),
                  child: Center(
                    child: Text(
                      '${widget.sowerCode}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
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
                  style: TextStyle(
                      color: Color(0xff018F9C),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}
