import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ootopia_app/data/models/general_config/general_config_model.dart';
import 'package:ootopia_app/shared/secure-store-mixin.dart';
import 'package:collection/collection.dart';
import 'package:share_extend/share_extend.dart';

class SowerInvitationCode extends StatefulWidget {
  final String sowerCode;
  const SowerInvitationCode({required this.sowerCode});

  @override
  _SowerInvitationCodeState createState() => _SowerInvitationCodeState();
}

class _SowerInvitationCodeState extends State<SowerInvitationCode> {
  SecureStoreMixin secureStoreMixin = SecureStoreMixin();
  String? sentSowerInvitationCode;
  String? receivedSowerInvitationCode;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = false;
    Future.delayed(Duration.zero).then((value) async {
      List<GeneralConfigModel> generalConfigModel =
          await this.secureStoreMixin.getGeneralConfig();

      GeneralConfigModel? sentSowerInvitation =
          generalConfigModel.singleWhereOrNull((element) =>
              element.name == "user_sent_sower_invitation_code_ooz");

      GeneralConfigModel? receivedSowerInvitation =
          generalConfigModel.singleWhereOrNull((element) =>
              element.name == "user_received_sower_invitation_code_ooz");

      sentSowerInvitationCode = NumberFormat('###0.00', Platform.localeName)
          .format(sentSowerInvitation?.value ?? 0);
      receivedSowerInvitationCode = NumberFormat('###0.00', Platform.localeName)
          .format(receivedSowerInvitation?.value ?? 0);
      Future.delayed(Duration(milliseconds: 100)).then((_) {
        setState(() {
          loading = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: loading,
      child: Column(
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
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8,
          ),
          Center(
            child: Text(
              AppLocalizations.of(context)!
                  .sendTheCodeBelowToInviteYourFriendsSower,
              textAlign: TextAlign.center,
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
                            .joinToOOTOPIA2
                            .replaceAll('%AMOUNT_OF_MONEY%',
                                '${receivedSowerInvitationCode!} OOz')
                            .replaceAll('%USER_CODE%', widget.sowerCode),
                        'text');
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
                        AppLocalizations.of(context)!.sendCode,
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
                    "${AppLocalizations.of(context)!.code}: ${widget.sowerCode}",
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
      ),
    );
  }
}
