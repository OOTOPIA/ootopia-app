import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ootopia_app/bloc/auth/auth_bloc.dart';

class CardInformationBalance extends StatelessWidget {
  final String iconForeground;
  final String iconBackground;
  final String balanceOfTransactions;
  final String originTransaction;
  final String toOrFrom;
  final String action;

  CardInformationBalance({
    required this.balanceOfTransactions,
    required this.iconForeground,
    required this.iconBackground,
    required this.toOrFrom,
    required this.originTransaction,
    required this.action
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
     
    var iconBackground = this.iconBackground.contains('.svg') ? SvgPicture.network(
        this.iconBackground,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
      )
      : Image.network(this.iconBackground,height: 52,width: 52,fit: BoxFit.cover);

    var iconForeground = this.iconForeground.isNotEmpty ? Image.network(this.iconForeground) : SvgPicture.asset("assets/icons/ooz_circle_icon_active.svg");

    return ListTile(
      contentPadding: EdgeInsets.only(top: 15, left: 5),
      leading: Container(
        width: 59,
        height: 56,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: iconBackground
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: EdgeInsets.all(2),
                  color: Colors.white,
                  child: Container(
                    width: 27,
                    height: 27,
                    child: iconForeground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text(
        getTransactionTitle(context),
        style: TextStyle(color: Color(0xff018F9C), fontSize: 12),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(this.originTransaction !="gratitude_reward") Text(
            getTransactionDescription(context),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                '$typeActionFromOrTo',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                ' ${this.toOrFrom.isEmpty ? "Ootopia" : this.toOrFrom}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
      trailing: Chip(
        labelPadding: this.balanceOfTransactions.length == 2
            ? EdgeInsets.only(left: 32)
            : this.balanceOfTransactions.length == 3
                ? EdgeInsets.only(left: 27)
                : this.balanceOfTransactions.length == 4
                    ? EdgeInsets.only(left: 20)
                    : this.balanceOfTransactions.length == 5
                        ? EdgeInsets.only(left: 13)
                        : EdgeInsets.only(left: 5),
        avatar: SvgPicture.asset(
          'assets/icons/ooz-coin-blue-small.svg',
          color: Color(colorOfBalance),
        ),
        backgroundColor: Colors.white,
        label: Text(
            '${this.action == "sent" ? '-' : ''}${this.balanceOfTransactions.length > 6 ? NumberFormat.compact().format(double.parse(this.balanceOfTransactions)).replaceAll('.', ',') : this.balanceOfTransactions.replaceAll('.', ',')}'),
      ),
    );
  }
}
