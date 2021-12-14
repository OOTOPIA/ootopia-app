import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:share_extend/share_extend.dart';

class DefaultInvitationCode extends StatefulWidget {
  final String defaultCode;
  final List<GeneralConfigModel> generalConfigModel;
  const DefaultInvitationCode(
      {required this.defaultCode, required this.generalConfigModel});

  @override
  _DefaultInvitationCodeState createState() => _DefaultInvitationCodeState();
}

class _DefaultInvitationCodeState extends State<DefaultInvitationCode> {
  SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  String? sentDefaultInvitationCode;
  String? receivedDefaultInvitationCode;

  @override
  void initState() {
    super.initState();

    GeneralConfigModel? sentDefaultInvitation = widget.generalConfigModel
        .singleWhereOrNull((element) =>
            element.name == "user_sent_default_invitation_code_ooz");

    GeneralConfigModel? receivedDefaultInvitation = widget.generalConfigModel
        .singleWhereOrNull((element) =>
            element.name == "user_received_default_invitation_code_ooz");

    sentDefaultInvitationCode = NumberFormat('###0.00', Platform.localeName)
        .format(sentDefaultInvitation?.value ?? 0);

    receivedDefaultInvitationCode = NumberFormat('###0.00', Platform.localeName)
        .format(receivedDefaultInvitation?.value ?? 0);
  }

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
          AppLocalizations.of(context)!.welcomeInvitationCode,
          style: TextStyle(
            color: Color(0xff003694),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: AppLocalizations.of(context)!.sendWelcomeInvitationCode,
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: " ${sentDefaultInvitationCode!} OOz ",
                style: TextStyle(
                    color: Color(0Xff003694), fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text: AppLocalizations.of(context)!
                      .forEachNewcomerYourFriendWillReceive),
              TextSpan(
                text: " ${receivedDefaultInvitationCode!} OOz ",
                style: TextStyle(
                    color: Color(0Xff003694), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  await ShareExtend.share(
                      AppLocalizations.of(context)!
                          .joinToOOTOPIA
                          .replaceAll('%AMOUNT_OF_MONEY%',
                              '${receivedDefaultInvitationCode!} OOz')
                          .replaceAll('%USER_CODE%', widget.defaultCode),
                      'text');
                },
                child: Container(
                  width: 228,
                  decoration: BoxDecoration(
                    color: Color(0xff003694),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    border: Border.all(
                      color: Color(0xff003694),
                    ),
                  ),
                  padding: EdgeInsets.all(9),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.sendCode,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "${AppLocalizations.of(context)!.code}: ${widget.defaultCode}",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      color: Color(0xff003694),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
