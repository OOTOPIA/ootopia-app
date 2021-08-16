import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';
import 'package:ootopia_app/shared/page-enum.dart' as PageRoute;

class CardInformationBalance extends StatelessWidget {
  final String iconForeground;
  final String iconBackground;
  final String balanceOfTransactions;
  final String originTransaction;
  final String toOrFrom;
  final String action;
  final String? otherUserId;

  CardInformationBalance({
    required this.balanceOfTransactions,
    required this.iconForeground,
    required this.iconBackground,
    required this.toOrFrom,
    required this.originTransaction,
    required this.action,
    this.otherUserId
  });

  String getTransactionDescription(context) {
    String origin = '';

    switch(originTransaction) {
      case 'total_game_completed':  
        origin = AppLocalizations.of(context)!.totalGameCompleted;
        break;
      case 'personal_goal_achieved':  
        origin = AppLocalizations.of(context)!.personalGoalAchieved;
        break;
      case 'gratitude_reward': 
        origin = AppLocalizations.of(context)!.gratitudeReward;
        break;
      case 'invitation_code': 
        origin = AppLocalizations.of(context)!.invitationCode;
        break;
    }

    return origin;
  }

  String getTransactionTitle(context) {
    String origin = '';

    switch(originTransaction) {
      case 'total_game_completed':  
        origin = AppLocalizations.of(context)!.regenerationGame;
        break;
      case 'personal_goal_achieved':  
        origin = AppLocalizations.of(context)!.regenerationGame;
        break;
      case 'gratitude_reward': 
        origin = AppLocalizations.of(context)!.gratitudeReward;
        break;
      case 'invitation_code': 
        origin = AppLocalizations.of(context)!.invitationCode;
        break;
    }

    return origin;
  }

  int colorOfBalance = 0xff003694;
  String typeActionFromOrTo = '';

  @override
  Widget build(BuildContext context) {
    switch (action) {
      case 'received':
        colorOfBalance = 0xff018F9C;
        typeActionFromOrTo =  AppLocalizations.of(context)!.from;
        break;
      case 'sent':
        colorOfBalance = 0xff000000;
        typeActionFromOrTo =  AppLocalizations.of(context)!.to;
        break;
      default:
    }

    void _goToProfile() async {
      Navigator.of(context).pushNamed(
        PageRoute.Page.profileScreen.route,
        arguments: {
          "id": this.otherUserId,
        },
      );
    }

    var iconBackground = this.iconBackground.contains('.svg') ? SvgPicture.network(
        this.iconBackground,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      )
      : Image.network(this.iconBackground,height: 52,width: 52,fit: BoxFit.cover);

    var iconForeground = this.iconForeground.isNotEmpty ? Image.network(this.iconForeground) : SvgPicture.asset("assets/icons/ooz_circle_icon_active.svg");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 66,
              height: 56,
              child: Stack(
                children: [
                  GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: iconBackground
                    ),
                    onTap: () {
                      if(this.otherUserId != null) {
                        _goToProfile();
                      }
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: EdgeInsets.all(1),
                        color: Colors.white,
                        child: Container(
                          width: 28,
                          height: 28,
                          child: iconForeground,
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),
            Container(// text and sent  
              child:
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getTransactionTitle(context),
                      style: TextStyle(
                        color: Color(0xff018F9C),
                        fontWeight: FontWeight.bold,
                        fontSize: 12
                      ),
                    ),
                    if (this.originTransaction !="gratitude_reward") Text(
                      getTransactionDescription(context),
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$typeActionFromOrTo',
                            style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 12
                            )
                          ),
                          TextSpan(
                            text: ' ${this.toOrFrom.isEmpty ? "Ootopia" : this.toOrFrom}',
                            style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ]
                      )
                    )
                  ],
                ),
            ),
          ],
        ),
        SizedBox( // wallet Ozz
          width: 80,
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/icons/ooz-coin-blue-small.svg',
                  color: Color(colorOfBalance),
                ),
                Text(
                  '${this.action == "sent" ? '-' : ''}${this.balanceOfTransactions.length > 6 ? NumberFormat.compact().format(double.parse(this.balanceOfTransactions)).replaceAll('.', ',') : this.balanceOfTransactions.replaceAll('.', ',')}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }
}
